import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/job_entry.dart';
import '../models/tip_entry.dart';
import '../services/storage_service.dart';
import '../services/tip_pdf_export.dart';
import '../theme/app_theme.dart';
import '../utils/currency_utils.dart';
import '../widgets/tip_entry_context_menu.dart';
import '../widgets/tip_list_item.dart';
import '../widgets/top_message.dart';

/// History UI with calendar, day summary, and entries.
class HistoryTab extends StatefulWidget {
  const HistoryTab({
    super.key,
    required this.loading,
    required this.tips,
    required this.storage,
    required this.jobs,
    required this.currencyCode,
    required this.roundUpEnabled,
    required this.onDeleteWithUndo,
    required this.onAddTip,
    required this.onRefreshTips,
  });

  final bool loading;
  final List<TipEntry> tips;
  final StorageService storage;
  final List<JobEntry> jobs;
  final String currencyCode;
  final bool roundUpEnabled;
  final Future<void> Function(TipEntry tip) onDeleteWithUndo;
  final Future<void> Function() onAddTip;
  final Future<void> Function() onRefreshTips;

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryPalette {
  static Color bg(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;
  static Color card(BuildContext context) => Theme.of(context).cardColor;
  static Color border(BuildContext context) => Theme.of(context).dividerColor;
  static const Color accent = AppTheme.brandOrange;
  static Color text(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;
  static Color textMuted(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium?.color ?? AppTheme.textSecondary;
}

class _HistoryTabState extends State<HistoryTab>
    with AutomaticKeepAliveClientMixin<HistoryTab> {
  late DateTime _visibleMonth;
  late DateTime _selectedDay;
  _HistoryRangeFilter _activeFilter = _HistoryRangeFilter.today;
  /// `null` = all jobs (matches on-screen list).
  String? _scopedJobId;

  @override
  void initState() {
    super.initState();
    final DateTime n = DateTime.now();
    _selectedDay = DateTime(n.year, n.month, n.day);
    _visibleMonth = DateTime(n.year, n.month, 1);
  }

  @override
  void didUpdateWidget(HistoryTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_scopedJobId != null &&
        !widget.jobs.any((JobEntry j) => j.id == _scopedJobId)) {
      setState(() => _scopedJobId = null);
    }
  }

  @override
  bool get wantKeepAlive => true;

  void _goMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(
        _visibleMonth.year,
        _visibleMonth.month + delta,
        1,
      );
    });
  }

  void _selectCalendarDay(DateTime day) {
    setState(() {
      _selectedDay = DateTime(day.year, day.month, day.day);
      if (day.year != _visibleMonth.year || day.month != _visibleMonth.month) {
        _visibleMonth = DateTime(day.year, day.month, 1);
      }
    });
  }

  DateTime _startOfDay(DateTime day) => DateTime(day.year, day.month, day.day);

  DateTime _endOfDay(DateTime day) =>
      DateTime(day.year, day.month, day.day, 23, 59, 59, 999);

  ({DateTime start, DateTime end}) _activeRangeForSelectedDay() {
    final DateTime selectedStart = _startOfDay(_selectedDay);
    switch (_activeFilter) {
      case _HistoryRangeFilter.today:
        return (start: selectedStart, end: _endOfDay(selectedStart));
      case _HistoryRangeFilter.week:
        final DateTime weekStart = selectedStart.subtract(
          Duration(days: selectedStart.weekday - DateTime.monday),
        );
        final DateTime weekEnd = weekStart.add(const Duration(days: 6));
        return (start: weekStart, end: _endOfDay(weekEnd));
      case _HistoryRangeFilter.month:
        final DateTime monthStart = DateTime(
          selectedStart.year,
          selectedStart.month,
          1,
        );
        final DateTime monthEnd = DateTime(
          selectedStart.year,
          selectedStart.month + 1,
          0,
        );
        return (start: monthStart, end: _endOfDay(monthEnd));
      case _HistoryRangeFilter.year:
        final DateTime yearStart = DateTime(selectedStart.year, 1, 1);
        final DateTime yearEnd = DateTime(selectedStart.year, 12, 31);
        return (start: yearStart, end: _endOfDay(yearEnd));
    }
  }

  List<TipEntry> _tipsForActiveRange() {
    final ({DateTime start, DateTime end}) range = _activeRangeForSelectedDay();
    final List<TipEntry> list =
        widget.tips
            .where(
              (TipEntry t) =>
                  !t.date.isBefore(range.start) && !t.date.isAfter(range.end),
            )
            .toList()
          ..sort((TipEntry a, TipEntry b) => b.date.compareTo(a.date));
    return list;
  }

  /// Tips currently shown in the summary, breakdown, and list (range + job scope).
  List<TipEntry> _tipsVisibleOnScreen() {
    final List<TipEntry> rangeTips = _tipsForActiveRange();
    if (_scopedJobId == null) {
      return rangeTips;
    }
    return rangeTips
        .where((TipEntry t) => t.jobId == _scopedJobId)
        .toList(growable: false);
  }

  static bool _isSameCalendarDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _historyExportFilterDescription() {
    final String localeName = Localizations.localeOf(context).toString();
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime sel = _selectedDay;
    final ({DateTime start, DateTime end}) range = _activeRangeForSelectedDay();

    final String timePart = switch (_activeFilter) {
      _HistoryRangeFilter.today => _isSameCalendarDay(sel, today)
          ? 'Today'
          : DateFormat.yMMMMd(localeName).format(sel),
      _HistoryRangeFilter.week => () {
        final DateTime start = range.start;
        final DateTime end = range.end;
        if (start.year == end.year && start.month == end.month) {
          return 'This Week (${DateFormat.MMM(localeName).format(start)} ${start.day}-${end.day}, ${end.year})';
        }
        return 'This Week (${DateFormat.MMMd(localeName).format(start)} - ${DateFormat.MMMd(localeName).format(end)}, ${end.year})';
      }(),
      _HistoryRangeFilter.month =>
        'This Month - ${DateFormat.yMMMM(localeName).format(sel)}',
      _HistoryRangeFilter.year => 'Year ${sel.year}',
    };

    if (_scopedJobId != null) {
      for (final JobEntry j in widget.jobs) {
        if (j.id == _scopedJobId) {
          return '${j.title} - $timePart';
        }
      }
    }
    return timePart;
  }

  Future<void> _exportPdf() async {
    final List<TipEntry> visible = _tipsVisibleOnScreen();
    if (visible.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No data to export')),
      );
      return;
    }

    final _FileExportAction? action = await _chooseFileExportAction();
    if (!mounted || action == null) return;

    final String filterDesc = _historyExportFilterDescription();
    final String reportTitle = 'TipFlow Report — $filterDesc';
    final String fileStem =
        'tipflow_report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}';

    final PdfExportResult result = await shareTipFlowIncomeReport(
      widget.tips,
      widget.jobs,
      rangeStart: null,
      rangeEnd: null,
      currencySymbol: currencySymbolFromCode(widget.currencyCode),
      openShareSheet: action == _FileExportAction.share,
      exportRows: visible,
      reportTitleLine: reportTitle,
      includeBestDaySummary: false,
      fileNameStem: fileStem,
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

  Future<_FileExportAction?> _chooseFileExportAction() async {
    return showModalBottomSheet<_FileExportAction>(
      context: context,
      builder: (BuildContext context) {
        final AppLocalizations l10n = AppLocalizations.of(context)!;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.save_alt_outlined),
                title: Text(l10n.saveToPhone),
                subtitle: Text(l10n.saveFileInDownloads('PDF')),
                onTap: () =>
                    Navigator.of(context).pop(_FileExportAction.saveToPhone),
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: Text(l10n.share),
                subtitle: Text(l10n.openAppsToShareFile('PDF')),
                onTap: () => Navigator.of(context).pop(_FileExportAction.share),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _confirmDeleteTip() async {
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final List<TipEntry> visibleTips = _tipsVisibleOnScreen();

    return Scaffold(
      backgroundColor: _HistoryPalette.bg(context),
      appBar: AppBar(
        backgroundColor: _HistoryPalette.bg(context),
        foregroundColor: _HistoryPalette.text(context),
        elevation: 0,
        title: Text(
          l10n.historyTitle,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: _HistoryPalette.text(context),
          ),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: l10n.reportPdfTooltip,
            onPressed: widget.loading ? null : _exportPdf,
            icon: const Icon(Icons.picture_as_pdf_outlined),
            color: _HistoryPalette.accent,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => widget.onAddTip(),
        backgroundColor: _HistoryPalette.accent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 32),
      ),
      body: widget.loading
          ? const Center(
              child: CircularProgressIndicator(color: _HistoryPalette.accent),
            )
          : RefreshIndicator(
              color: _HistoryPalette.accent,
              backgroundColor: _HistoryPalette.card(context),
              onRefresh: () async {
                await widget.onRefreshTips();
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                children: <Widget>[
                  const SizedBox(height: 10),
                  _MonthHeader(
                    month: _visibleMonth,
                    onPrev: () => _goMonth(-1),
                    onNext: () => _goMonth(1),
                  ),
                  const SizedBox(height: 10),
                  _MonthCalendar(
                    visibleMonth: _visibleMonth,
                    selectedDay: _selectedDay,
                    today: today,
                    onSelectDay: _selectCalendarDay,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.filters,
                    style: TextStyle(
                      color: _HistoryPalette.textMuted(context),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _HistoryRangeFilterChips(
                    selected: _activeFilter,
                    onChanged: (_HistoryRangeFilter filter) {
                      setState(() => _activeFilter = filter);
                    },
                  ),
                  if (widget.jobs.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 12),
                    Text(
                      l10n.jobs,
                      style: TextStyle(
                        color: _HistoryPalette.textMuted(context),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _HistoryJobScopeChips(
                      jobs: widget.jobs,
                      scopedJobId: _scopedJobId,
                      onChanged: (String? jobId) {
                        setState(() => _scopedJobId = jobId);
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  _HistoryDailySummaryCard(
                    selectedDay: _selectedDay,
                    today: today,
                    dayTips: visibleTips,
                    currencyCode: widget.currencyCode,
                    activeFilter: _activeFilter,
                  ),
                  const SizedBox(height: 12),
                  _HistoryJobBreakdownSection(
                    jobs: widget.jobs,
                    rangeTips: visibleTips,
                    currencyCode: widget.currencyCode,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.entries,
                    style: TextStyle(
                      color: _HistoryPalette.text(context),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._buildTipList(visibleTips),
                ],
              ),
            ),
    );
  }

  List<Widget> _buildTipList(List<TipEntry> list) {
    if (list.isEmpty) {
      return <Widget>[const _HistoryEmptyState()];
    }
    return list
        .map(
          (TipEntry e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Dismissible(
              key: ValueKey<String>('history-tip-${e.id}'),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (_) => _confirmDeleteTip(),
              onDismissed: (_) {
                HapticFeedback.heavyImpact();
                widget.onDeleteWithUndo(e);
              },
              child: TipListItem(
                entry: e,
                darkStyle: false,
                currencyCode: widget.currencyCode,
                onLongPress: () {
                  showTipEntryActions(
                    context,
                    entry: e,
                    storage: widget.storage,
                    jobs: widget.jobs,
                    currencyCode: widget.currencyCode,
                    roundUpEnabled: widget.roundUpEnabled,
                    onTipsMutated: widget.onRefreshTips,
                    onDeleteWithUndo: widget.onDeleteWithUndo,
                  );
                },
              ),
            ),
          ),
        )
        .toList();
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.month,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime month;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final String localeName = Localizations.localeOf(context).toString();
    final String label = DateFormat.yMMMM(localeName).format(month);
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left),
          color: _HistoryPalette.text(context),
        ),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _HistoryPalette.text(context),
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
          color: _HistoryPalette.text(context),
        ),
      ],
    );
  }
}

class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({
    required this.visibleMonth,
    required this.selectedDay,
    required this.today,
    required this.onSelectDay,
  });

  final DateTime visibleMonth;
  final DateTime selectedDay;
  final DateTime today;
  final ValueChanged<DateTime> onSelectDay;

  @override
  Widget build(BuildContext context) {
    final String localeName = Localizations.localeOf(context).toString();
    final List<String> weekLabels = List<String>.generate(7, (int i) {
      final DateTime d = DateTime(2023, 1, 1 + i);
      return DateFormat.E(localeName).format(d);
    });
    final int y = visibleMonth.year;
    final int m = visibleMonth.month;
    final DateTime first = DateTime(y, m, 1);
    final int daysInMonth = DateTime(y, m + 1, 0).day;
    final int offset = first.weekday % 7;
    final int cellsBefore = offset;
    final int cellsMain = daysInMonth;
    final int totalUsed = cellsBefore + cellsMain;
    final int trailing = (7 - (totalUsed % 7)) % 7;
    final int totalCells = totalUsed + trailing;

    return Column(
      children: <Widget>[
        Row(
          children: List<Widget>.generate(7, (int i) {
            final bool weekend = i == 0 || i == 6;
            return Expanded(
              child: Center(
                child: Text(
                  weekLabels[i],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: weekend
                        ? _HistoryPalette.accent
                        : _HistoryPalette.textMuted(context),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalCells,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 1.4,
          ),
          itemBuilder: (BuildContext context, int index) {
            if (index < cellsBefore) {
              final int prevMonth = m == 1 ? 12 : m - 1;
              final int prevYear = m == 1 ? y - 1 : y;
              final int lastDayPrev = DateTime(y, m, 0).day;
              final int dayNum = lastDayPrev - (cellsBefore - index - 1);
              final DateTime d = DateTime(prevYear, prevMonth, dayNum);
              return _DayCell(
                label: '$dayNum',
                muted: true,
                selected: _sameDay(d, selectedDay),
                isToday: _sameDay(d, today),
                onTap: () => onSelectDay(d),
              );
            }
            final int dayNum = index - cellsBefore + 1;
            if (dayNum <= daysInMonth) {
              final DateTime d = DateTime(y, m, dayNum);
              return _DayCell(
                label: '$dayNum',
                muted: false,
                selected: _sameDay(d, selectedDay),
                isToday: _sameDay(d, today),
                onTap: () => onSelectDay(d),
              );
            }
            final int nextDay = index - cellsBefore - daysInMonth + 1;
            final int nextMonth = m == 12 ? 1 : m + 1;
            final int nextYear = m == 12 ? y + 1 : y;
            final DateTime d = DateTime(nextYear, nextMonth, nextDay);
            return _DayCell(
              label: '$nextDay',
              muted: true,
              selected: _sameDay(d, selectedDay),
              isToday: _sameDay(d, today),
              onTap: () => onSelectDay(d),
            );
          },
        ),
      ],
    );
  }

  static bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.label,
    required this.muted,
    required this.selected,
    required this.isToday,
    required this.onTap,
  });

  final String label;
  final bool muted;
  final bool selected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color fg = muted ? AppTheme.textHint : _HistoryPalette.text(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? _HistoryPalette.accent
                  : (isToday
                        ? _HistoryPalette.accent.withValues(alpha: 0.45)
                        : _HistoryPalette.border(context)),
              width: selected ? 2 : 1,
            ),
            color: selected
                ? _HistoryPalette.accent.withValues(alpha: 0.12)
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: fg,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}

enum _HistoryRangeFilter { today, week, month, year }

enum _FileExportAction { saveToPhone, share }

class _HistoryRangeFilterChips extends StatelessWidget {
  const _HistoryRangeFilterChips({
    required this.selected,
    required this.onChanged,
  });

  final _HistoryRangeFilter selected;
  final ValueChanged<_HistoryRangeFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Color muted = _HistoryPalette.textMuted(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          _FilterChipItem(
            label: l10n.filterToday,
            selected: selected == _HistoryRangeFilter.today,
            muted: muted,
            onTap: () => onChanged(_HistoryRangeFilter.today),
          ),
          const SizedBox(width: 8),
          _FilterChipItem(
            label: l10n.filterWeek,
            selected: selected == _HistoryRangeFilter.week,
            muted: muted,
            onTap: () => onChanged(_HistoryRangeFilter.week),
          ),
          const SizedBox(width: 8),
          _FilterChipItem(
            label: l10n.filterMonth,
            selected: selected == _HistoryRangeFilter.month,
            muted: muted,
            onTap: () => onChanged(_HistoryRangeFilter.month),
          ),
          const SizedBox(width: 8),
          _FilterChipItem(
            label: l10n.filterYear,
            selected: selected == _HistoryRangeFilter.year,
            muted: muted,
            onTap: () => onChanged(_HistoryRangeFilter.year),
          ),
        ],
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  const _FilterChipItem({
    required this.label,
    required this.selected,
    required this.muted,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color muted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? _HistoryPalette.accent.withValues(alpha: 0.15)
          : _HistoryPalette.card(context),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? _HistoryPalette.accent
                  : _HistoryPalette.border(context),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? _HistoryPalette.accent : muted,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryDailySummaryCard extends StatelessWidget {
  const _HistoryDailySummaryCard({
    required this.selectedDay,
    required this.today,
    required this.dayTips,
    required this.currencyCode,
    required this.activeFilter,
  });

  final DateTime selectedDay;
  final DateTime today;
  final List<TipEntry> dayTips;
  final String currencyCode;
  final _HistoryRangeFilter activeFilter;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String localeName = Localizations.localeOf(context).toString();
    final Color secondary = _HistoryPalette.textMuted(context);
    final bool isToday =
        selectedDay.year == today.year &&
        selectedDay.month == today.month &&
        selectedDay.day == today.day;
    final String dayLabel = switch (activeFilter) {
      _HistoryRangeFilter.today =>
        isToday
            ? l10n.labelToday
            : DateFormat.yMMMd(localeName).format(selectedDay),
      _HistoryRangeFilter.week => l10n.weekOf(
        DateFormat.MMMd(localeName).format(selectedDay),
      ),
      _HistoryRangeFilter.month => DateFormat.yMMMM(
        localeName,
      ).format(selectedDay),
      _HistoryRangeFilter.year => DateFormat.y(localeName).format(selectedDay),
    };
    final double total = dayTips.fold<double>(
      0,
      (double s, TipEntry t) => s + t.amount,
    );
    final int tipCount = dayTips.length;
    final double hourly = tipCount == 0 ? 0 : total / 8;
    final String totalText = formatMoney(
      total,
      currencyCode: currencyCode,
      decimalDigits: 2,
    );
    final String hourlyText = formatMoney(
      hourly,
      currencyCode: currencyCode,
      decimalDigits: 0,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _HistoryPalette.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _HistoryPalette.border(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.calendar_today_outlined,
            color: AppTheme.brandOrange,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  dayLabel,
                  style: TextStyle(
                    color: secondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  totalText,
                  style: const TextStyle(
                    color: AppTheme.brandOrange,
                    fontWeight: FontWeight.w800,
                    fontSize: 40,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                l10n.tipsCount(tipCount),
                style: TextStyle(
                  color: secondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.hourlyRateFormat(hourlyText),
                style: const TextStyle(
                  color: AppTheme.brandOrange,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryEmptyState extends StatelessWidget {
  const _HistoryEmptyState();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: _HistoryPalette.accent.withValues(alpha: 0.85),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noDataFound,
            style: TextStyle(
              color: _HistoryPalette.text(context),
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.noIncomeRecorded,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _HistoryPalette.textMuted(context).withValues(alpha: 0.9),
              fontSize: 14,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryJobScopeChips extends StatelessWidget {
  const _HistoryJobScopeChips({
    required this.jobs,
    required this.scopedJobId,
    required this.onChanged,
  });

  final List<JobEntry> jobs;
  final String? scopedJobId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: const Text('All jobs'),
              selected: scopedJobId == null,
              selectedColor: _HistoryPalette.accent.withValues(alpha: 0.2),
              side: BorderSide(
                color:
                    scopedJobId == null
                        ? _HistoryPalette.accent
                        : theme.dividerColor,
              ),
              onSelected: (_) => onChanged(null),
            ),
          ),
          ...jobs.map((JobEntry job) {
            final bool selected = scopedJobId == job.id;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(job.title),
                selected: selected,
                selectedColor: _HistoryPalette.accent.withValues(alpha: 0.2),
                side: BorderSide(
                  color: selected ? _HistoryPalette.accent : theme.dividerColor,
                ),
                onSelected: (_) => onChanged(job.id),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _HistoryJobBreakdownSection extends StatelessWidget {
  const _HistoryJobBreakdownSection({
    required this.jobs,
    required this.rangeTips,
    required this.currencyCode,
  });

  final List<JobEntry> jobs;
  final List<TipEntry> rangeTips;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    if (rangeTips.isEmpty) {
      return const SizedBox.shrink();
    }
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final Map<String?, List<TipEntry>> tipsByJob = <String?, List<TipEntry>>{};
    for (final TipEntry tip in rangeTips) {
      tipsByJob.putIfAbsent(tip.jobId, () => <TipEntry>[]).add(tip);
    }

    final List<_JobBreakdownData> rows =
        jobs
            .map((JobEntry job) {
              final List<TipEntry> jobTips = tipsByJob[job.id] ?? <TipEntry>[];
              final double total = jobTips.fold<double>(
                0,
                (double sum, TipEntry tip) => sum + tip.amount,
              );
              return _JobBreakdownData(
                label: job.title,
                tipCount: jobTips.length,
                total: total,
              );
            })
            .where((_JobBreakdownData r) => r.tipCount > 0)
            .toList(growable: true);

    final List<TipEntry> noJobTips = tipsByJob[null] ?? <TipEntry>[];
    if (noJobTips.isNotEmpty) {
      final double total = noJobTips.fold<double>(
        0,
        (double sum, TipEntry tip) => sum + tip.amount,
      );
      rows.add(
        _JobBreakdownData(
          label: 'No job',
          tipCount: noJobTips.length,
          total: total,
        ),
      );
    }

    rows.sort((a, b) => b.total.compareTo(a.total));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _HistoryPalette.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _HistoryPalette.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.jobs,
            style: TextStyle(
              color: _HistoryPalette.text(context),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          ...rows.map(
            (_JobBreakdownData row) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _JobBreakdownRow(
                label: row.label,
                tipCountText: l10n.tipsCount(row.tipCount),
                totalText: formatMoney(
                  row.total,
                  currencyCode: currencyCode,
                  decimalDigits: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JobBreakdownRow extends StatelessWidget {
  const _JobBreakdownRow({
    required this.label,
    required this.tipCountText,
    required this.totalText,
  });

  final String label;
  final String tipCountText;
  final String totalText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: TextStyle(
                  color: _HistoryPalette.text(context),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Text(
                tipCountText,
                style: TextStyle(
                  color: _HistoryPalette.textMuted(context),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Text(
          totalText,
          style: const TextStyle(
            color: AppTheme.brandOrange,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _JobBreakdownData {
  const _JobBreakdownData({
    required this.label,
    required this.tipCount,
    required this.total,
  });

  final String label;
  final int tipCount;
  final double total;
}
