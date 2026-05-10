import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../l10n/world_languages.dart';
import '../models/job_entry.dart';
import '../models/tip_entry.dart';
import '../services/app_settings_service.dart';
import '../services/quick_add_settings_service.dart';
import '../services/storage_service.dart';
import '../services/sync_service.dart';
import '../services/tip_export.dart';
import '../services/tip_pdf_export.dart';
import '../theme/app_theme.dart';
import '../utils/currency_utils.dart';
import '../widgets/quick_add_customize_dialog.dart';
import '../widgets/top_message.dart';
import '../widgets/tip_entry_context_menu.dart';
import '../widgets/tip_list_item.dart';
import 'add_entry_screen.dart';
import 'history_tab.dart';
import 'jobs_screen.dart';

/// When there is at least one job, always pick a concrete active job (never
/// `null`, which previously meant "all jobs" on the dashboard).
String? _preferredActiveJobId({
  required List<JobEntry> jobs,
  required String? currentActiveId,
  required String? persistedActiveJobId,
}) {
  if (jobs.isEmpty) return null;
  if (currentActiveId != null &&
      jobs.any((JobEntry j) => j.id == currentActiveId)) {
    return currentActiveId;
  }
  if (persistedActiveJobId != null &&
      jobs.any((JobEntry j) => j.id == persistedActiveJobId)) {
    return persistedActiveJobId;
  }
  return jobs.first.id;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.storage,
    this.darkModeEnabled = false,
    this.onDarkModeChanged,
    this.onLocaleChanged,
  });

  final StorageService storage;
  final bool darkModeEnabled;
  final Future<void> Function(bool enabled)? onDarkModeChanged;
  final Future<void> Function(Locale? locale)? onLocaleChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuickAddSettingsService _quickAddSettingsService =
      QuickAddSettingsService();
  final AppSettingsService _appSettingsService = AppSettingsService();

  List<TipEntry> _tips = <TipEntry>[];
  /// Sum of [TipEntry.amount] for [_tips]; kept in lockstep whenever [_tips] changes.
  double _totalTips = 0;
  List<JobEntry> _jobs = <JobEntry>[];
  List<double> _quickAddValues = kDefaultQuickAddValues;
  List<String> _quickAddNotes = kDefaultQuickAddNotes;
  String _currencyCode = kDefaultCurrencyCode;
  bool _roundUpEnabled = kDefaultRoundUpEnabled;
  bool _loading = true;
  int _selectedIndex = 0;
  late DateTime _selectedDay;
  String? _activeJobId;
  String _appVersion = '';
  String? _dataLoadError;

  @override
  void initState() {
    super.initState();
    final DateTime n = DateTime.now();
    _selectedDay = DateTime(n.year, n.month, n.day);
    unawaited(_loadPackageVersion());
    unawaited(_initializeHomeData());
  }

  /// Recomputes [_totalTips] from [_tips].
  void _updateTotal() {
    _totalTips = _tips.fold<double>(
      0,
      (double sum, TipEntry tip) => sum + tip.amount,
    );
    debugPrint('_updateTotal: total=$_totalTips, tips=${_tips.length}');
  }

  Future<void> _initializeHomeData() async {
    final DateTime? persistedDay =
        await _appSettingsService.loadDashboardSelectedDay();
    if (!mounted) return;
    if (persistedDay != null) {
      setState(() => _selectedDay = persistedDay);
    }
    // Keep the dashboard behind a loader until persisted data is available.
    await _loadPersistedData();
    await Future.wait(<Future<void>>[_loadQuickAddValues(), _loadAppSettings()]);
    unawaited(_syncThenReloadTips());
  }

  Future<void> _syncThenReloadTips() async {
    try {
      await SyncService.instance.syncTips();
      if (!mounted) return;
      await _loadTips();
      if (mounted) setState(() {});
    } catch (e, st) {
      debugPrint('syncThenReloadTips failed: $e\n$st');
    }
  }

  Future<void> _loadPackageVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _appVersion = info.version);
  }

  /// Initial tips + jobs load (single failure surface, no parallel race on
  /// [_dataLoadError]).
  Future<void> _loadPersistedData() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _dataLoadError = null;
      });
    }
    // Tips are critical for dashboard totals: if this fails, we block UI and
    // surface recovery action.
    List<TipEntry> tips = <TipEntry>[];
    try {
      tips = await widget.storage.loadTips();
      tips.sort((TipEntry a, TipEntry b) => b.date.compareTo(a.date));
      debugPrint(
        'loadPersistedData: tips loaded=${tips.length}, '
        'first=${tips.isEmpty ? 'none' : tips.first.date.toIso8601String()}',
      );
    } catch (e, st) {
      debugPrint('loadPersistedData tips failed: $e\n$st');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _dataLoadError = e.toString();
      });
      return;
    }

    // Jobs are secondary for initial totals; never wipe already loaded tips if
    // jobs/settings are malformed.
    List<JobEntry> jobs = <JobEntry>[];
    String? persistedActiveJobId;
    try {
      jobs = await widget.storage.loadJobs();
      persistedActiveJobId = await _appSettingsService.loadActiveJobId();
    } catch (e, st) {
      debugPrint('loadPersistedData jobs failed: $e\n$st');
      jobs = <JobEntry>[];
      persistedActiveJobId = null;
      if (mounted) {
        setState(() {
          _dataLoadError ??= e.toString();
        });
      }
    }

    if (!mounted) return;
    final String? nextActive = _preferredActiveJobId(
      jobs: jobs,
      currentActiveId: _activeJobId,
      persistedActiveJobId: persistedActiveJobId,
    );
    final double calculatedSum = tips.fold<double>(0, (sum, t) => sum + t.amount);
    debugPrint(
      'DEBUG before setState: tips count = ${tips.length}, calculated sum = $calculatedSum',
    );
    setState(() {
      _tips = tips;
      _totalTips = _tips.fold<double>(0, (double sum, TipEntry t) => sum + t.amount);
      _jobs = jobs;
      _activeJobId = nextActive;
      _loading = false;
    });
    debugPrint('DEBUG: tips count = ${_tips.length}, totalTips = $_totalTips');
    await _appSettingsService.saveActiveJobId(nextActive);
  }

  /// Reloads tips from storage without toggling [_loading]. That flag is only
  /// for the initial [_loadPersistedData] gate; setting it here blanked the
  /// whole dashboard (spinner / empty totals) whenever History pull-to-refresh
  /// or similar called this method.
  Future<void> _loadTips() async {
    try {
      final List<TipEntry> tips = await widget.storage.loadTips();
      tips.sort((TipEntry a, TipEntry b) => b.date.compareTo(a.date));
      debugPrint(
        '_loadTips: tips loaded=${tips.length}, '
        'first=${tips.isEmpty ? 'none' : tips.first.date.toIso8601String()}',
      );
      if (!mounted) return;
      setState(() {
        _tips = tips;
        _dataLoadError = null;
        _totalTips = _tips.fold<double>(0, (double sum, TipEntry t) => sum + t.amount);
      });
    } catch (e, st) {
      debugPrint('loadTips failed: $e\n$st');
      if (!mounted) return;
      setState(() {
        _dataLoadError ??= e.toString();
      });
    }
  }

  Future<void> _loadQuickAddValues() async {
    final String? jobIdForQuickSettings =
        _jobs.isEmpty ? null : (_activeJobId ?? _jobs.first.id);
    final List<double> values = await _quickAddSettingsService.loadValues(
      jobId: jobIdForQuickSettings,
    );
    final List<String> notes = await _quickAddSettingsService.loadNotes(
      jobId: jobIdForQuickSettings,
    );
    if (!mounted) return;
    setState(() {
      _quickAddValues = values;
      _quickAddNotes = notes;
    });
  }

  Future<void> _loadAppSettings() async {
    final String currency = await _appSettingsService.loadCurrencyCode();
    final bool roundUp = await _appSettingsService.loadRoundUpEnabled();
    if (!mounted) return;
    setState(() {
      _currencyCode = currency;
      _roundUpEnabled = roundUp;
    });
  }

  Future<void> _loadJobs() async {
    try {
      final List<JobEntry> jobs = await widget.storage.loadJobs();
      final String? persistedActiveJobId = await _appSettingsService
          .loadActiveJobId();
      if (!mounted) return;
      final String? nextActive = _preferredActiveJobId(
        jobs: jobs,
        currentActiveId: _activeJobId,
        persistedActiveJobId: persistedActiveJobId,
      );
      setState(() {
        _jobs = jobs;
        _activeJobId = nextActive;
      });
      await _appSettingsService.saveActiveJobId(nextActive);
    } catch (e, st) {
      debugPrint('loadJobs failed: $e\n$st');
      if (!mounted) return;
      setState(() {
        _jobs = <JobEntry>[];
        _activeJobId = null;
        _dataLoadError ??= e.toString();
      });
    }
  }

  Future<void> _resetAppAfterLoadFailure() async {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    if (l10n == null) return;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.resetAppConfirmTitle),
          content: Text(l10n.resetAppConfirmBody),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.resetApp),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;
    try {
      await widget.storage.resetLocalStorageAfterCorruption();
      if (!mounted) return;
      await _loadPersistedData();
      if (!mounted) return;
      if (_dataLoadError != null) {
        showTopMessage(context, message: '${l10n.resetAppFailed}: $_dataLoadError');
        return;
      }
      showTopMessage(context, message: l10n.resetAppSuccess);
    } catch (e) {
      if (!mounted) return;
      showTopMessage(context, message: '${l10n.resetAppFailed}: $e');
    }
  }

  double _applyRoundUp(double value) {
    if (!_roundUpEnabled) return value;
    return value.ceilToDouble();
  }

  Future<void> _noOpDarkModeChange(bool enabled) async {}

  void _showTopTipSavedMessage() {
    if (!mounted) return;
    showTopMessage(context, message: AppLocalizations.of(context)!.tipSaved);
  }

  Future<void> _showNoJobDialog() async {
    if (!mounted) return;
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        final ThemeData theme = Theme.of(dialogContext);
        return AlertDialog(
          backgroundColor: AppTheme.card,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppTheme.divider),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 22, 24, 10),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Row(
            children: <Widget>[
              const Icon(Icons.work_outline, color: AppTheme.brandOrangeDeep),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.noJobDialogTitle,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            l10n.noJobDialogMessage,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
              height: 1.35,
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.add_business_outlined),
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  await _openJobsManager();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.brandOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                label: Text(
                  l10n.noJobDialogCreateJob,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openQuickCustomizeFromDashboard() async {
    if (_jobs.isEmpty) {
      await _showNoJobDialog();
      return;
    }
    await _openQuickCustomizeFromHome();
  }

  Future<void> _saveInstantQuickTip(double amount, String? notes) async {
    if (_jobs.isEmpty) {
      await _showNoJobDialog();
      return;
    }
    HapticFeedback.lightImpact();
    final DateTime now = DateTime.now();
    // Same semantics as AddEntryScreen / date picker: local wall time on the
    // selected day. Using DateTime.utc here made quick tips sort above normal
    // tips added at the same clock time (wrong instant for compareTo).
    final DateTime when = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
      now.hour,
      now.minute,
      now.second,
    );
    await widget.storage.addTip(
      TipEntry(
        id: '${DateTime.now().microsecondsSinceEpoch}',
        amount: _applyRoundUp(amount),
        date: when,
        type: 'cash',
        notes: notes,
        jobId: _activeJobId,
      ),
    );
    if (!mounted) return;
    await _loadTips();
    if (!mounted) return;
    _showTopTipSavedMessage();
  }

  Future<void> _openQuickCustomizeFromHome() async {
    final bool? saved = await showQuickAddCustomizeDialog(
      context: context,
      service: _quickAddSettingsService,
      jobId: _jobs.isEmpty ? null : (_activeJobId ?? _jobs.first.id),
    );
    if (!mounted) return;
    if (saved == true) {
      await _loadQuickAddValues();
      if (!mounted) return;
      HapticFeedback.lightImpact();
      showTopMessage(
        context,
        message: AppLocalizations.of(context)!.quickButtonsUpdated,
      );
    }
  }

  Future<void> _openAddTipScreen() async {
    if (_jobs.isEmpty) {
      await _showNoJobDialog();
      return;
    }
    final bool? saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (BuildContext context) => AddEntryScreen(
          storage: widget.storage,
          currencyCode: _currencyCode,
          roundUpEnabled: _roundUpEnabled,
          jobs: _jobs,
          initialJobId: _activeJobId,
        ),
      ),
    );
    if (!mounted) return;
    if (saved == true) {
      await _loadTips();
      if (!mounted) return;
      _showTopTipSavedMessage();
    }
  }

  Future<void> _deleteWithUndo(TipEntry entry) async {
    HapticFeedback.heavyImpact();
    setState(() {
      _tips = _tips.where((TipEntry t) => t.id != entry.id).toList();
      _updateTotal();
    });
    await widget.storage.deleteTip(entry.id);

    if (!mounted) return;
    showTopMessage(
      context,
      message: AppLocalizations.of(context)!.tipDeletedUndo,
      duration: const Duration(seconds: 5),
      actionLabel: AppLocalizations.of(context)!.undo,
      onAction: () async {
        await widget.storage.addTip(entry);
        if (mounted) {
          await _loadTips();
        }
      },
    );
  }

  Future<void> _deleteAllData() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final AppLocalizations d = AppLocalizations.of(context)!;
        final ThemeData theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: AppTheme.card,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: AppTheme.divider),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(
            d.deleteAllDataTitle,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 44,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            d.deleteAllDataBody,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 17,
              height: 1.35,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.brandOrangeDeep,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: Text(d.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.brandOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: Text(d.deleteAll),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    await widget.storage.clearTips();
    await widget.storage.clearJobs();
    if (!mounted) return;
    await _loadTips();
    if (!mounted) return;
    showTopMessage(context, message: AppLocalizations.of(context)!.allDataDeleted);
  }

  Future<void> _exportTipsToCsv() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    if (_tips.isEmpty) {
      showTopMessage(context, message: l10n.noTipsToExport);
      return;
    }

    final List<TipEntry>? tipsToExport = await _selectTipsForExport();
    if (!mounted || tipsToExport == null) return;
    if (tipsToExport.isEmpty) {
      showTopMessage(context, message: AppLocalizations.of(context)!.noTipsForPeriod);
      return;
    }

    final String csv = widget.storage.tipsToExportCsv(tipsToExport);
    final _FileExportAction? action = await _chooseFileExportAction('CSV');
    if (!mounted || action == null) return;
    final CsvExportResult result = await exportTipsCsv(
      csv,
      openShareSheet: action == _FileExportAction.share,
    );
    if (!mounted) return;

    if (action == _FileExportAction.saveToPhone && result.savedToDownloads) {
      showTopMessage(context, message: 'CSV saved to Downloads');
    } else if (result.shareOpened) {
      showTopMessage(context, message: AppLocalizations.of(context)!.csvExported);
    } else {
      showTopMessage(context, message: AppLocalizations.of(context)!.exportUnavailable);
    }
  }

  Future<void> _exportProfilePdfReport() async {
    final _FileExportAction? action = await _chooseFileExportAction('PDF');
    if (!mounted || action == null) return;
    final PdfExportResult result = await shareGetTipIncomeReport(
      _tips,
      _jobs,
      rangeStart: null,
      rangeEnd: null,
      currencySymbol: currencySymbolFromCode(_currencyCode),
      openShareSheet: action == _FileExportAction.share,
    );
    if (!mounted) return;
    if (action == _FileExportAction.saveToPhone && result.savedToDownloads) {
      showTopMessage(context, message: 'PDF saved to Downloads');
    } else if (result.shareOpened) {
      showTopMessage(context, message: AppLocalizations.of(context)!.pdfReportReady);
    } else {
      showTopMessage(
        context,
        message: AppLocalizations.of(context)!.pdfExportUnavailable,
      );
    }
  }

  Future<_FileExportAction?> _chooseFileExportAction(String fileType) async {
    return showModalBottomSheet<_FileExportAction>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppTheme.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        final AppLocalizations l10n = AppLocalizations.of(context)!;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.save_alt_outlined,
                  color: AppTheme.brandOrangeDeep,
                ),
                title: Text(
                  l10n.saveToPhone,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  l10n.saveFileInDownloads(fileType),
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                onTap: () =>
                    Navigator.of(context).pop(_FileExportAction.saveToPhone),
              ),
              ListTile(
                leading: const Icon(
                  Icons.share_outlined,
                  color: AppTheme.brandOrangeDeep,
                ),
                title: Text(
                  l10n.share,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  l10n.openAppsToShareFile(fileType),
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                onTap: () => Navigator.of(context).pop(_FileExportAction.share),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showPlaceholderMessage(String labelKey) async {
    if (!mounted) return;
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String feature = labelKey == 'rate' ? l10n.rateApp : l10n.contactUs;
    showTopMessage(context, message: l10n.comingSoon(feature));
  }

  Future<void> _openContactEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'hellogittip@gmail.com',
      queryParameters: <String, String>{
        'subject': 'Get Tip support',
      },
    );
    final bool opened = await launchUrl(emailUri);
    if (!mounted || opened) return;
    showTopMessage(context, message: 'Could not open email app');
  }

  Future<void> _shareExperience() async {
    if (!mounted) return;
    showTopMessage(context, message: AppLocalizations.of(context)!.thanksFeedback);
  }

  Future<void> _setCurrencyCode(String code) async {
    await _appSettingsService.saveCurrencyCode(code);
    if (!mounted) return;
    setState(() => _currencyCode = code);
    showTopMessage(context, message: AppLocalizations.of(context)!.currencySet(code));
  }

  Future<void> _setRoundUpEnabled(bool enabled) async {
    await _appSettingsService.saveRoundUpEnabled(enabled);
    if (!mounted) return;
    setState(() => _roundUpEnabled = enabled);
  }

  Future<void> _setActiveJobId(String? jobId) async {
    await _appSettingsService.saveActiveJobId(jobId);
    if (!mounted) return;
    setState(() => _activeJobId = jobId);
    await _loadQuickAddValues();
  }

  Future<void> _openJobsManager() async {
    final String? selected = await Navigator.of(context).push<String?>(
      MaterialPageRoute<String?>(
        builder: (BuildContext context) => JobsScreen(
          storage: widget.storage,
          currencyCode: _currencyCode,
          activeJobId: _activeJobId,
        ),
      ),
    );
    await _loadJobs();
    if (!mounted) return;
    if (selected != null && _jobs.any((JobEntry j) => j.id == selected)) {
      await _setActiveJobId(selected);
    }
  }

  Future<List<TipEntry>?> _selectTipsForExport() async {
    _ExportRangeChoice selected = _ExportRangeChoice.today;
    final DateTime now = DateTime.now();
    DateTime rangeStart = DateTime(now.year, now.month, now.day);
    DateTime rangeEnd = DateTime(now.year, now.month, now.day);

    final _ExportDialogSelection? selection =
        await showDialog<_ExportDialogSelection>(
          context: context,
          builder: (BuildContext dialogContext) {
            return StatefulBuilder(
              builder:
                  (
                    BuildContext innerContext,
                    void Function(void Function()) setDialogState,
                  ) {
                    final AppLocalizations l10n = AppLocalizations.of(
                      innerContext,
                    )!;
                    final String localeName = Localizations.localeOf(
                      innerContext,
                    ).toString();
                    final DateFormat labelFormat = DateFormat.yMMMd(localeName);
                    Future<void> pickStartDate() async {
                      final DateTime? picked = await showDatePicker(
                        context: innerContext,
                        initialDate: rangeStart,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(now.year + 5),
                      );
                      if (picked == null) return;
                      setDialogState(() {
                        rangeStart = picked;
                        if (rangeEnd.isBefore(rangeStart)) {
                          rangeEnd = rangeStart;
                        }
                      });
                    }

                    Future<void> pickEndDate() async {
                      final DateTime? picked = await showDatePicker(
                        context: innerContext,
                        initialDate: rangeEnd,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(now.year + 5),
                      );
                      if (picked == null) return;
                      setDialogState(() {
                        rangeEnd = picked;
                        if (rangeEnd.isBefore(rangeStart)) {
                          rangeStart = rangeEnd;
                        }
                      });
                    }

                    return AlertDialog(
                      backgroundColor: AppTheme.card,
                      surfaceTintColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: const BorderSide(color: AppTheme.divider),
                      ),
                      title: Text(l10n.exportCsvTitle),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: <Widget>[
                              ChoiceChip(
                                label: Text(l10n.exportRangeToday),
                                selected: selected == _ExportRangeChoice.today,
                                selectedColor: AppTheme.brandOrange.withValues(
                                  alpha: 0.14,
                                ),
                                side: BorderSide(
                                  color: AppTheme.divider,
                                ),
                                onSelected: (_) {
                                  setDialogState(
                                    () => selected = _ExportRangeChoice.today,
                                  );
                                },
                              ),
                              ChoiceChip(
                                label: Text(l10n.exportRangeWeek),
                                selected: selected == _ExportRangeChoice.week,
                                selectedColor: AppTheme.brandOrange.withValues(
                                  alpha: 0.14,
                                ),
                                side: BorderSide(
                                  color: AppTheme.divider,
                                ),
                                onSelected: (_) {
                                  setDialogState(
                                    () => selected = _ExportRangeChoice.week,
                                  );
                                },
                              ),
                              ChoiceChip(
                                label: Text(l10n.exportRangeMonth),
                                selected: selected == _ExportRangeChoice.month,
                                selectedColor: AppTheme.brandOrange.withValues(
                                  alpha: 0.14,
                                ),
                                side: BorderSide(
                                  color: AppTheme.divider,
                                ),
                                onSelected: (_) {
                                  setDialogState(
                                    () => selected = _ExportRangeChoice.month,
                                  );
                                },
                              ),
                              ChoiceChip(
                                label: Text(l10n.exportRangeCustom),
                                selected:
                                    selected == _ExportRangeChoice.customRange,
                                selectedColor: AppTheme.brandOrange.withValues(
                                  alpha: 0.14,
                                ),
                                side: BorderSide(
                                  color: AppTheme.divider,
                                ),
                                onSelected: (_) {
                                  setDialogState(
                                    () => selected =
                                        _ExportRangeChoice.customRange,
                                  );
                                },
                              ),
                            ],
                          ),
                          if (selected ==
                              _ExportRangeChoice.customRange) ...<Widget>[
                            const SizedBox(height: 14),
                            OutlinedButton.icon(
                              onPressed: pickStartDate,
                              icon: const Icon(Icons.calendar_today_outlined),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.brandOrangeDeep,
                                side: BorderSide(
                                  color: AppTheme.divider,
                                ),
                                backgroundColor: AppTheme.card,
                              ),
                              label: Text(
                                l10n.exportFrom(labelFormat.format(rangeStart)),
                              ),
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              onPressed: pickEndDate,
                              icon: const Icon(Icons.event_outlined),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.brandOrangeDeep,
                                side: BorderSide(
                                  color: AppTheme.divider,
                                ),
                                backgroundColor: AppTheme.card,
                              ),
                              label: Text(
                                l10n.exportTo(labelFormat.format(rangeEnd)),
                              ),
                            ),
                          ],
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: Text(l10n.cancel),
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(
                              _ExportDialogSelection(
                                choice: selected,
                                rangeStart: rangeStart,
                                rangeEnd: rangeEnd,
                              ),
                            );
                          },
                          child: Text(l10n.export),
                        ),
                      ],
                    );
                  },
            );
          },
        );

    if (selection == null) return null;

    final DateTime start;
    final DateTime end;

    switch (selection.choice) {
      case _ExportRangeChoice.today:
        start = DateTime(now.year, now.month, now.day);
        end = now;
      case _ExportRangeChoice.week:
        start = now.subtract(const Duration(days: 7));
        end = now;
      case _ExportRangeChoice.month:
        start = DateTime(now.year, now.month, 1);
        end = now;
      case _ExportRangeChoice.customRange:
        start = DateTime(
          selection.rangeStart.year,
          selection.rangeStart.month,
          selection.rangeStart.day,
        );
        end = DateTime(
          selection.rangeEnd.year,
          selection.rangeEnd.month,
          selection.rangeEnd.day,
          23,
          59,
          59,
          999,
        );
    }

    final List<TipEntry> filtered =
        _tips
            .where(
              (TipEntry tip) =>
                  !tip.date.isBefore(start) && !tip.date.isAfter(end),
            )
            .toList()
          ..sort((TipEntry a, TipEntry b) => b.date.compareTo(a.date));
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final TextStyle navLabelStyle = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: theme.textTheme.bodyMedium?.color ?? AppTheme.textSecondary,
    );

    final List<Widget> pages = <Widget>[
      _DashboardTab(
        loading: _loading,
        tips: _tips,
        totalTipsAmount: _totalTips,
        jobs: _jobs,
        activeJobId: _activeJobId,
        onJobChanged: (String nextJobId) {
          unawaited(_setActiveJobId(nextJobId));
        },
        currencyCode: _currencyCode,
        quickAddValues: _quickAddValues,
        quickAddNotes: _quickAddNotes,
        selectedDay: _selectedDay,
        onSelectDay: (DateTime day) {
          setState(() => _selectedDay = day);
          unawaited(_appSettingsService.saveDashboardSelectedDay(day));
        },
        onPresetQuickAdd: (int index) {
          final String raw = _quickAddNotes[index].trim();
          unawaited(
            _saveInstantQuickTip(
              _quickAddValues[index],
              raw.isEmpty ? null : raw,
            ),
          );
        },
        onCustomQuickAdd: () {
          unawaited(_openQuickCustomizeFromDashboard());
        },
        onQuickCustomize: () {
          unawaited(_openQuickCustomizeFromDashboard());
        },
        onAddTip: _openAddTipScreen,
        onDeleteTip: _deleteWithUndo,
        onTipLongPress: (TipEntry e) {
          showTipEntryActions(
            context,
            entry: e,
            storage: widget.storage,
            jobs: _jobs,
            currencyCode: _currencyCode,
            roundUpEnabled: _roundUpEnabled,
            onTipsMutated: _loadTips,
            onDeleteWithUndo: _deleteWithUndo,
          );
        },
      ),
      HistoryTab(
        loading: _loading,
        tips: _tips,
        storage: widget.storage,
        jobs: _jobs,
        currencyCode: _currencyCode,
        roundUpEnabled: _roundUpEnabled,
        onDeleteWithUndo: _deleteWithUndo,
        onAddTip: _openAddTipScreen,
        onRefreshTips: _loadTips,
      ),
      _ProfileTab(
        tips: _tips,
        currencyCode: _currencyCode,
        roundUpEnabled: _roundUpEnabled,
        darkModeEnabled: widget.darkModeEnabled,
        appVersion: _appVersion.isEmpty ? '—' : _appVersion,
        dataLoadError: _dataLoadError,
        onResetAppAfterLoadFailure: _resetAppAfterLoadFailure,
        onOpenSettings: _openQuickCustomizeFromHome,
        onCurrencyChanged: _setCurrencyCode,
        onRoundUpChanged: _setRoundUpEnabled,
        onDarkModeChanged: widget.onDarkModeChanged ?? _noOpDarkModeChange,
        onAddJob: _openJobsManager,
        onDeleteAllData: _deleteAllData,
        onExportCsv: _exportTipsToCsv,
        onExportPdf: _exportProfilePdfReport,
        onShareExperience: _shareExperience,
        onRateApp: () => _showPlaceholderMessage('rate'),
        onContactUs: _openContactEmail,
        onLocaleChanged: widget.onLocaleChanged,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStatePropertyAll<TextStyle>(navLabelStyle),
          iconTheme: WidgetStatePropertyAll<IconThemeData>(
            IconThemeData(
              size: 20,
              color:
                  theme.textTheme.bodyMedium?.color ?? AppTheme.textSecondary,
            ),
          ),
        ),
        child: NavigationBar(
          height: 60,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() => _selectedIndex = index);
          },
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: l10n.navHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.history_outlined),
              selectedIcon: const Icon(Icons.history),
              label: l10n.navHistory,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: l10n.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab({
    required this.loading,
    required this.tips,
    required this.totalTipsAmount,
    required this.jobs,
    required this.activeJobId,
    required this.onJobChanged,
    required this.currencyCode,
    required this.quickAddValues,
    required this.quickAddNotes,
    required this.selectedDay,
    required this.onSelectDay,
    required this.onPresetQuickAdd,
    required this.onCustomQuickAdd,
    required this.onQuickCustomize,
    required this.onAddTip,
    required this.onDeleteTip,
    required this.onTipLongPress,
  });

  final bool loading;
  final List<TipEntry> tips;
  /// Sum of all tips from parent; do not re-fold [tips] here for this display.
  final double totalTipsAmount;
  final List<JobEntry> jobs;
  final String? activeJobId;
  final ValueChanged<String> onJobChanged;
  final String currencyCode;
  final List<double> quickAddValues;
  final List<String> quickAddNotes;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onSelectDay;
  final void Function(int index) onPresetQuickAdd;
  final VoidCallback onCustomQuickAdd;
  final VoidCallback onQuickCustomize;
  final Future<void> Function() onAddTip;
  final Future<void> Function(TipEntry tip) onDeleteTip;
  final void Function(TipEntry entry) onTipLongPress;

  static bool _isSameCalendarDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Uses the tip's instant in local time vs [day]'s calendar date so UTC
  /// stored timestamps (e.g. from sync) match the same day as the UI chips.
  static bool _isTipOnLocalCalendarDay(TipEntry t, DateTime day) {
    final DateTime localTipDate = t.date.toLocal();
    return localTipDate.year == day.year &&
        localTipDate.month == day.month &&
        localTipDate.day == day.day;
  }

  /// Legacy tips may have null [TipEntry.jobId]; treat them like the first job.
  static bool _tipBelongsToJob(
    TipEntry tip,
    String jobId,
    List<JobEntry> jobs,
  ) {
    if (tip.jobId == jobId) return true;
    return tip.jobId == null &&
        jobs.isNotEmpty &&
        jobId == jobs.first.id;
  }

  double _dayTotal(List<TipEntry> list, DateTime day) {
    return list
        .where((TipEntry t) => _isTipOnLocalCalendarDay(t, day))
        .fold<double>(0, (double s, TipEntry t) => s + t.amount);
  }

  int _dayTipCount(List<TipEntry> list, DateTime day) {
    return list.where((TipEntry t) => _isTipOnLocalCalendarDay(t, day)).length;
  }

  String _greeting(DateTime now, AppLocalizations l10n) {
    if (now.hour < 12) return l10n.greetingMorning;
    if (now.hour < 18) return l10n.greetingAfternoon;
    return l10n.greetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String localeName = Localizations.localeOf(context).toString();
    final ThemeData theme = Theme.of(context);
    final Color onSurface = theme.colorScheme.onSurface;
    final Color secondary =
        theme.textTheme.bodyMedium?.color ?? AppTheme.textSecondary;
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final List<TipEntry> scopedTips;
    if (jobs.isEmpty) {
      scopedTips = tips;
    } else {
      final String jobId = activeJobId ?? jobs.first.id;
      scopedTips = tips
          .where((TipEntry tip) => _tipBelongsToJob(tip, jobId, jobs))
          .toList(growable: false);
    }

    final double dayTotal = _dayTotal(scopedTips, selectedDay);
    final int count = _dayTipCount(scopedTips, selectedDay);
    final double hourly = count == 0 ? 0 : dayTotal / 8;

    final String totalStr = formatMoney(dayTotal, currencyCode: currencyCode);
    final String hourlyStr = formatMoney(
      hourly,
      currencyCode: currencyCode,
      decimalDigits: 0,
    );

    const int kRecentEntriesLimit = 50;
    final List<TipEntry> recentTips = scopedTips
        .where((TipEntry t) => _isTipOnLocalCalendarDay(t, selectedDay))
        .take(kRecentEntriesLimit)
        .toList();
    final List<TipEntry> dayTipsAllJobs = tips
        .where((TipEntry t) => _isTipOnLocalCalendarDay(t, selectedDay))
        .toList(growable: false);

    final String daySubtitle = _isSameCalendarDay(selectedDay, today)
        ? l10n.labelToday
        : DateFormat.yMMMd(localeName).format(selectedDay);

    final double topInset = MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_dashboard',
        onPressed: () {
          unawaited(onAddTip());
        },
        backgroundColor: AppTheme.brandOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 32),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.brandOrange),
            )
          : ListView(
              padding: EdgeInsets.fromLTRB(20, topInset + 8, 20, 88),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _greeting(now, l10n),
                        style: TextStyle(
                          fontSize: 14,
                          color: secondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 72,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      final DateTime day = selectedDay.add(
                        Duration(days: index - 2),
                      );
                      final bool selected = _isSameCalendarDay(
                        day,
                        selectedDay,
                      );
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _DayChip(
                          day: day,
                          selected: selected,
                          localeName: localeName,
                          onTap: () => onSelectDay(
                            DateTime(day.year, day.month, day.day),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                if (jobs.isNotEmpty) ...<Widget>[
                  _JobSwitcherRow(
                    jobs: jobs,
                    activeJobId: activeJobId,
                    currencyCode: currencyCode,
                    dayTips: dayTipsAllJobs,
                    onChanged: onJobChanged,
                  ),
                  const SizedBox(height: 12),
                ],
                _LightSummaryCard(
                  dayLabel: daySubtitle,
                  totalText: totalStr,
                  hourlyText: l10n.hourlyRateFormat(hourlyStr),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: _QuickAmountButton(
                        label: _quickLabel(quickAddValues[0], currencyCode),
                        subtitle: quickAddNotes.isNotEmpty
                            ? quickAddNotes[0].trim()
                            : '',
                        onTap: () => onPresetQuickAdd(0),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _QuickAmountButton(
                        label: _quickLabel(quickAddValues[1], currencyCode),
                        subtitle: quickAddNotes.length > 1
                            ? quickAddNotes[1].trim()
                            : '',
                        onTap: () => onPresetQuickAdd(1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _QuickAmountButton(
                        label: _quickLabel(quickAddValues[2], currencyCode),
                        subtitle: quickAddNotes.length > 2
                            ? quickAddNotes[2].trim()
                            : '',
                        onTap: () => onPresetQuickAdd(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _QuickAmountButton(
                        label: l10n.customQuickLabel,
                        subtitle: l10n.customQuickSubtitle,
                        onTap: onCustomQuickAdd,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.recentEntries,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                if (recentTips.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      l10n.noTipsYet,
                      style: TextStyle(color: secondary),
                    ),
                  )
                else
                  ...recentTips.map(
                    (TipEntry e) => _HomeTipDismissible(
                      entry: e,
                      currencyCode: currencyCode,
                      onDelete: () => onDeleteTip(e),
                      onLongPress: () => onTipLongPress(e),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _JobSwitcherRow extends StatelessWidget {
  const _JobSwitcherRow({
    required this.jobs,
    required this.activeJobId,
    required this.currencyCode,
    required this.dayTips,
    required this.onChanged,
  });

  final List<JobEntry> jobs;
  final String? activeJobId;
  final String currencyCode;
  final List<TipEntry> dayTips;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color onSurface = theme.colorScheme.onSurface;
    final String effectiveActiveId = activeJobId ?? jobs.first.id;
    final List<Widget> chips = <Widget>[
      ...jobs.map((JobEntry job) {
        final double total = dayTips
            .where((TipEntry tip) => tip.jobId == job.id)
            .fold<double>(0, (double sum, TipEntry t) => sum + t.amount);
        return _JobChip(
          label: _jobDisplayName(job),
          selected: effectiveActiveId == job.id,
          amount: total,
          chipColor: _jobColorFromKey(job.colorKey),
          currencyCode: currencyCode,
          onTap: () => onChanged(job.id),
        );
      }),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Switch job',
          style: TextStyle(
            color: onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: chips),
        ),
      ],
    );
  }
}

class _JobChip extends StatelessWidget {
  const _JobChip({
    required this.label,
    required this.selected,
    required this.amount,
    required this.chipColor,
    required this.currencyCode,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final double amount;
  final Color chipColor;
  final String currencyCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color chipTextColor = chipColor;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          '$label • ${formatMoney(amount, currencyCode: currencyCode, decimalDigits: 0)}',
        ),
        selected: selected,
        selectedColor: chipColor.withValues(alpha: 0.30),
        backgroundColor: chipColor.withValues(alpha: 0.12),
        side: BorderSide(
          color: chipColor.withValues(alpha: selected ? 0.75 : 0.45),
        ),
        checkmarkColor: chipColor,
        labelStyle: TextStyle(
          color: chipTextColor,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
        ),
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.day,
    required this.selected,
    required this.localeName,
    required this.onTap,
  });

  final DateTime day;
  final bool selected;
  final String localeName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color onSurface = theme.colorScheme.onSurface;
    final Color divider = theme.dividerColor;
    final String label = '${DateFormat.E(localeName).format(day)} ${day.day}';
    return Material(
      color: selected ? AppTheme.brandOrange : theme.cardColor,
      borderRadius: BorderRadius.circular(12),
      elevation: selected ? 0 : 1,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppTheme.brandOrange : divider,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _LightSummaryCard extends StatelessWidget {
  const _LightSummaryCard({
    required this.dayLabel,
    required this.totalText,
    required this.hourlyText,
  });

  final String dayLabel;
  final String totalText;
  final String hourlyText;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Color secondary =
        theme.textTheme.bodyMedium?.color ?? AppTheme.textSecondary;
    return Material(
      color: theme.cardColor,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.dailySummary,
              style: TextStyle(
                fontSize: 12,
                color: secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              dayLabel,
              style: TextStyle(
                fontSize: 12,
                color: secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.totalEarnings,
              style: TextStyle(fontSize: 12, color: secondary),
            ),
            const SizedBox(height: 4),
            Text(
              totalText,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: AppTheme.brandOrange,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              hourlyText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.brandOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAmountButton extends StatelessWidget {
  const _QuickAmountButton({
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final String label;

  /// Shown under [label] in smaller grey text (e.g. preset note or hint).
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool hasSubtitle = subtitle.isNotEmpty;
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.brandOrangeDeep,
        side: BorderSide(color: theme.dividerColor),
        backgroundColor: theme.cardColor,
        padding: EdgeInsets.symmetric(
          vertical: hasSubtitle ? 8 : 12,
          horizontal: 6,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          if (hasSubtitle) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color:
                    theme.textTheme.bodyMedium?.color ?? AppTheme.textSecondary,
                height: 1.2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HomeTipDismissible extends StatelessWidget {
  const _HomeTipDismissible({
    required this.entry,
    required this.currencyCode,
    required this.onDelete,
    required this.onLongPress,
  });

  final TipEntry entry;
  final String currencyCode;
  final Future<void> Function() onDelete;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<String>('home-tip-${entry.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        final bool? confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            final AppLocalizations d = AppLocalizations.of(context)!;
            return AlertDialog(
              title: Text(d.deleteThisTip),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(d.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(d.delete),
                ),
              ],
            );
          },
        );
        return confirmed ?? false;
      },
      onDismissed: (_) {
        onDelete();
      },
      child: TipListItem(
        entry: entry,
        currencyCode: currencyCode,
        onLongPress: onLongPress,
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({
    required this.tips,
    required this.currencyCode,
    required this.roundUpEnabled,
    required this.darkModeEnabled,
    required this.appVersion,
    this.dataLoadError,
    required this.onResetAppAfterLoadFailure,
    required this.onOpenSettings,
    required this.onCurrencyChanged,
    required this.onRoundUpChanged,
    required this.onDarkModeChanged,
    required this.onAddJob,
    required this.onDeleteAllData,
    required this.onExportCsv,
    required this.onExportPdf,
    required this.onShareExperience,
    required this.onRateApp,
    required this.onContactUs,
    this.onLocaleChanged,
  });

  final List<TipEntry> tips;
  final String currencyCode;
  final bool roundUpEnabled;
  final bool darkModeEnabled;
  final String appVersion;
  final String? dataLoadError;
  final Future<void> Function() onResetAppAfterLoadFailure;
  final Future<void> Function() onOpenSettings;
  final Future<void> Function(String code) onCurrencyChanged;
  final Future<void> Function(bool enabled) onRoundUpChanged;
  final Future<void> Function(bool enabled) onDarkModeChanged;
  final Future<void> Function() onAddJob;
  final Future<void> Function() onDeleteAllData;
  final Future<void> Function() onExportCsv;
  final Future<void> Function() onExportPdf;
  final Future<void> Function() onShareExperience;
  final Future<void> Function() onRateApp;
  final Future<void> Function() onContactUs;
  final Future<void> Function(Locale? locale)? onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String localeName = Localizations.localeOf(context).toString();
    final int totalCount = tips.length;
    final double totalAmount = tips.fold<double>(
      0,
      (double sum, TipEntry t) => sum + t.amount,
    );
    final Set<String> uniqueDays = tips
        .map((TipEntry t) => DateFormat('yyyy-MM-dd').format(t.date.toLocal()))
        .toSet();
    final double averageTipPerDay = uniqueDays.isEmpty
        ? 0
        : totalAmount / uniqueDays.length;
    final double averageHourlyRate = uniqueDays.isEmpty
        ? 0
        : totalAmount / (uniqueDays.length * 8);

    final Map<String, double> byDay = <String, double>{};
    for (final TipEntry t in tips) {
      final String day = DateFormat('yyyy-MM-dd').format(t.date.toLocal());
      byDay[day] = (byDay[day] ?? 0) + t.amount;
    }

    String bestDay = '-';
    double bestDayAmount = 0;
    byDay.forEach((String day, double amount) {
      if (amount > bestDayAmount) {
        bestDayAmount = amount;
        bestDay = day;
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navProfile)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: <Widget>[
          _ProfileSectionCard(
            title: l10n.statsSection,
            children: <Widget>[
              _SummaryRow(label: l10n.totalTipsLabel, value: '$totalCount'),
              _SummaryRow(
                label: l10n.totalEarningsLabel,
                value: formatMoney(
                  totalAmount,
                  currencyCode: currencyCode,
                  decimalDigits: 0,
                ),
              ),
              _SummaryRow(
                label: l10n.averageDayLabel,
                value: formatMoney(
                  averageTipPerDay,
                  currencyCode: currencyCode,
                ),
              ),
              _SummaryRow(
                label: l10n.bestDayLabel,
                value: bestDayAmount == 0
                    ? '-'
                    : DateFormat(
                        'MMM d',
                        localeName,
                      ).format(DateTime.parse(bestDay)),
              ),
              _SummaryRow(
                label: l10n.avgHourlyRateLabel,
                value: formatMoney(
                  averageHourlyRate,
                  currencyCode: currencyCode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ProfileSectionCard(
            title: l10n.settingsSection,
            children: <Widget>[
              if (dataLoadError != null) ...<Widget>[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange.shade800,
                  ),
                  title: Text(
                    l10n.dataLoadFailedTitle,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    l10n.dataLoadFailedBody,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => onResetAppAfterLoadFailure(),
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.resetApp),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.orange.shade800,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const Divider(height: 24),
              ],
              _ProfileLanguageRow(onLocaleChanged: onLocaleChanged),
              _ProfileCurrencyRow(
                value: currencyCode,
                onChanged: onCurrencyChanged,
              ),
              _ProfileRoundUpRow(
                value: roundUpEnabled,
                onChanged: onRoundUpChanged,
              ),
              _ProfileActionRow(
                icon: Icons.settings,
                title: l10n.jobs,
                onTap: onAddJob,
              ),
              _ProfileActionRow(
                icon: Icons.tune,
                title: l10n.quickButtons,
                onTap: onOpenSettings,
              ),
              _ProfileActionRow(
                icon: Icons.outbox_outlined,
                title: l10n.exportCsv,
                onTap: onExportCsv,
                accent: true,
              ),
              _ProfileActionRow(
                icon: Icons.backup_outlined,
                title: l10n.backupTips,
                onTap: onExportCsv,
                accent: true,
              ),
              _ProfileActionRow(
                icon: Icons.picture_as_pdf_outlined,
                title: l10n.pdfReports,
                onTap: onExportPdf,
              ),
              _ProfileActionRow(
                icon: Icons.favorite_border,
                title: l10n.shareExperience,
                onTap: onShareExperience,
              ),
              _ProfileActionRow(
                icon: Icons.delete_outline,
                title: l10n.deleteAllData,
                onTap: onDeleteAllData,
                danger: true,
              ),
              _ProfileSwitchVisualRow(
                icon: Icons.dark_mode_outlined,
                title: l10n.darkMode,
                value: darkModeEnabled,
                onChanged: onDarkModeChanged,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ProfileSectionCard(
            title: l10n.supportSection,
            children: <Widget>[
              _ProfileActionRow(
                icon: Icons.star_outline,
                title: l10n.rateTheApp,
                onTap: onRateApp,
              ),
              _ProfileActionRow(
                icon: Icons.email_outlined,
                title: l10n.contactUsLabel,
                onTap: onContactUs,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.info_outline,
                  color: AppTheme.brandOrange,
                ),
                title: Text(
                  l10n.versionLabel(appVersion),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileSectionCard extends StatelessWidget {
  const _ProfileSectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.brandOrange,
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _ProfileActionRow extends StatelessWidget {
  const _ProfileActionRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.danger = false,
    this.accent = false,
  });

  final IconData icon;
  final String title;
  final Future<void> Function() onTap;
  final bool danger;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final Color onSurface = Theme.of(context).colorScheme.onSurface;
    final Color c = danger
        ? Colors.red.shade700
        : accent
        ? AppTheme.brandOrangeDeep
        : onSurface;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: danger
            ? Colors.red.shade700
            : accent
            ? AppTheme.brandOrangeDeep
            : AppTheme.brandOrange,
      ),
      title: Text(
        title,
        style: TextStyle(color: c, fontWeight: FontWeight.w600),
      ),
      trailing: Icon(Icons.chevron_right, color: c),
      onTap: () => onTap(),
    );
  }
}

class _ProfileSwitchVisualRow extends StatelessWidget {
  const _ProfileSwitchVisualRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final Future<void> Function(bool enabled) onChanged;

  @override
  Widget build(BuildContext context) {
    final Color onSurface = Theme.of(context).colorScheme.onSurface;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppTheme.brandOrange),
      title: Text(
        title,
        style: TextStyle(color: onSurface, fontWeight: FontWeight.w600),
      ),
      trailing: Switch(
        value: value,
        onChanged: (bool enabled) => onChanged(enabled),
        activeThumbColor: AppTheme.brandOrange,
      ),
      onTap: () => onChanged(!value),
    );
  }
}

class _ProfileLanguageRow extends StatefulWidget {
  const _ProfileLanguageRow({required this.onLocaleChanged});

  final Future<void> Function(Locale? locale)? onLocaleChanged;

  @override
  State<_ProfileLanguageRow> createState() => _ProfileLanguageRowState();
}

class _ProfileLanguageRowState extends State<_ProfileLanguageRow> {
  final AppSettingsService _settings = AppSettingsService();
  String _languageCode = 'system';

  List<DropdownMenuItem<String>> _buildLanguageItems(AppLocalizations l10n) {
    return <DropdownMenuItem<String>>[
      DropdownMenuItem<String>(
        value: 'system',
        child: Text('🌐 ${l10n.languageSystemDefault}'),
      ),
      ...kSelectableWorldLanguages.map(
        (AppLanguageOption language) => DropdownMenuItem<String>(
          value: language.code,
          child: Text('${language.flag} ${language.name}'),
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final Locale? saved = await _settings.loadSavedLocale();
    if (!mounted) return;
    setState(() {
      _languageCode = saved == null ? 'system' : saved.languageCode;
    });
  }

  Future<void> _onChanged(String? code) async {
    if (code == null || widget.onLocaleChanged == null) return;
    if (code == 'system') {
      await widget.onLocaleChanged!(null);
    } else {
      await widget.onLocaleChanged!(Locale(code));
    }
    if (!mounted) return;
    setState(() => _languageCode = code);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Color onSurface = Theme.of(context).colorScheme.onSurface;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.language, color: AppTheme.brandOrange),
      title: Text(
        l10n.language,
        style: TextStyle(color: onSurface, fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: DropdownButtonHideUnderline(
        child: SizedBox(
          width: 220,
          child: DropdownButton<String>(
            isExpanded: true,
            value: _languageCode,
            items: _buildLanguageItems(l10n),
            onChanged: _onChanged,
          ),
        ),
      ),
    );
  }
}

class _ProfileCurrencyRow extends StatelessWidget {
  const _ProfileCurrencyRow({required this.value, required this.onChanged});

  final String value;
  final Future<void> Function(String code) onChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Color onSurface = Theme.of(context).colorScheme.onSurface;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.attach_money, color: AppTheme.brandOrange),
      title: Text(
        l10n.currency,
        style: TextStyle(color: onSurface, fontWeight: FontWeight.w600),
      ),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: kSupportedCurrencyCodes
              .map(
                (String code) => DropdownMenuItem<String>(
                  value: code,
                  child: Text(currencyDisplayLabel(code)),
                ),
              )
              .toList(),
          onChanged: (String? next) {
            if (next == null) return;
            onChanged(next);
          },
        ),
      ),
    );
  }
}

class _ProfileRoundUpRow extends StatelessWidget {
  const _ProfileRoundUpRow({required this.value, required this.onChanged});

  final bool value;
  final Future<void> Function(bool enabled) onChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Color onSurface = Theme.of(context).colorScheme.onSurface;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.rounded_corner, color: AppTheme.brandOrange),
      title: Text(
        l10n.roundUp,
        style: TextStyle(color: onSurface, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(l10n.roundUpSubtitle),
      trailing: Switch(
        value: value,
        onChanged: (bool enabled) => onChanged(enabled),
        activeThumbColor: AppTheme.brandOrange,
      ),
    );
  }
}

enum _ExportRangeChoice { today, week, month, customRange }

enum _FileExportAction { saveToPhone, share }

class _ExportDialogSelection {
  _ExportDialogSelection({
    required this.choice,
    required this.rangeStart,
    required this.rangeEnd,
  });

  final _ExportRangeChoice choice;
  final DateTime rangeStart;
  final DateTime rangeEnd;
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final Color secondary =
        Theme.of(context).textTheme.bodyMedium?.color ?? AppTheme.textSecondary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Text(label, style: TextStyle(color: secondary)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

String _quickLabel(double amount, String currencyCode) {
  final String value = amount == amount.roundToDouble()
      ? amount.toStringAsFixed(0)
      : amount.toStringAsFixed(2);
  final String symbol = currencySymbolFromCode(currencyCode);
  return '$symbol$value';
}

String _jobDisplayName(JobEntry job) {
  final String employer = (job.employer ?? '').trim();
  if (employer.isEmpty) return job.title;
  return '${job.title} — $employer';
}

Color _jobColorFromKey(String colorKey) {
  switch (colorKey) {
    case 'green':
      return const Color(0xFF4CAF50);
    case 'blue':
      return const Color(0xFF2196F3);
    case 'red':
      return const Color(0xFFE53935);
    case 'orange':
      return const Color(0xFFFF9800);
    case 'purple':
      return const Color(0xFF9C27B0);
    case 'pink':
      return const Color(0xFFE91E63);
    case 'teal':
      return const Color(0xFF009688);
    default:
      return AppTheme.brandOrange;
  }
}
