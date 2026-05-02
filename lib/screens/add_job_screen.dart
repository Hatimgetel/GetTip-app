import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../models/job_entry.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../utils/currency_utils.dart';
import '../widgets/top_message.dart';

/// Add Job form styled like Home/History with an accent color picker.
class AddJobScreen extends StatefulWidget {
  const AddJobScreen({
    super.key,
    required this.storage,
    this.currencyCode = 'USD',
    this.existingJob,
  });

  final StorageService storage;
  final String currencyCode;
  final JobEntry? existingJob;

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobPalette {
  static const Color accent = AppTheme.brandOrange;
  static const Color fieldFill = AppTheme.card;
  static const Color border = AppTheme.divider;
  static const Color label = AppTheme.textSecondary;
  static const Color hint = AppTheme.textHint;
  static const Color dayUnselected = Color(0xFFF1F1F1);
}

final List<MapEntry<String, Color>> _colorChoices = <MapEntry<String, Color>>[
  const MapEntry<String, Color>('green', Color(0xFF4CAF50)),
  const MapEntry<String, Color>('blue', Color(0xFF2196F3)),
  const MapEntry<String, Color>('red', Color(0xFFE53935)),
  const MapEntry<String, Color>('orange', Color(0xFFFF9800)),
  const MapEntry<String, Color>('purple', Color(0xFF9C27B0)),
  const MapEntry<String, Color>('pink', Color(0xFFE91E63)),
  const MapEntry<String, Color>('teal', Color(0xFF009688)),
];

/// Weekdays 1 = Monday … 7 = Sunday (DateTime.weekday).
const List<MapEntry<int, String>> _weekdayChoices = <MapEntry<int, String>>[
  MapEntry<int, String>(1, 'Mon'),
  MapEntry<int, String>(2, 'Tue'),
  MapEntry<int, String>(3, 'Wed'),
  MapEntry<int, String>(4, 'Thu'),
  MapEntry<int, String>(5, 'Fri'),
  MapEntry<int, String>(6, 'Sat'),
  MapEntry<int, String>(7, 'Sun'),
];

class _AddJobScreenState extends State<AddJobScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _employerController = TextEditingController();
  final TextEditingController _hourlyController = TextEditingController();

  String _selectedColorKey = _colorChoices.first.key;
  final Set<int> _selectedWeekdays = <int>{1, 2, 3, 4, 5};
  bool get _isEditing => widget.existingJob != null;

  @override
  void initState() {
    super.initState();
    final JobEntry? existing = widget.existingJob;
    if (existing == null) return;
    _titleController.text = existing.title;
    _employerController.text = existing.employer ?? '';
    _hourlyController.text = existing.hourlyRate == null
        ? ''
        : existing.hourlyRate!.toStringAsFixed(2);
    _selectedColorKey = existing.colorKey;
    _selectedWeekdays
      ..clear()
      ..addAll(existing.workDays);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _employerController.dispose();
    _hourlyController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration({required String hint, Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _AddJobPalette.hint),
      prefixIcon: prefix,
      filled: true,
      fillColor: _AddJobPalette.fieldFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _AddJobPalette.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _AddJobPalette.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _AddJobPalette.accent, width: 1.4),
      ),
    );
  }

  String? _validateTitle(String? value) {
    final String t = value?.trim() ?? '';
    if (t.isEmpty) return AppLocalizations.of(context)!.titleIsRequired;
    return null;
  }

  Future<void> _save() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final String hourlyRaw = _hourlyController.text.trim();
    double? hourly;
    if (hourlyRaw.isNotEmpty) {
      hourly = double.tryParse(hourlyRaw);
      if (hourly == null || hourly < 0) {
        showTopMessage(
          context,
          message: l10n.enterValidHourlyRate,
        );
        return;
      }
    }

    HapticFeedback.lightImpact();
    final JobEntry job = JobEntry(
      id: widget.existingJob?.id ?? '${DateTime.now().microsecondsSinceEpoch}',
      colorKey: _selectedColorKey,
      title: _titleController.text.trim(),
      employer: _employerController.text.trim().isEmpty
          ? null
          : _employerController.text.trim(),
      hourlyRate: hourly,
      workDays: _selectedWeekdays.toList()..sort(),
    );
    if (_isEditing) {
      await widget.storage.updateJob(job);
    } else {
      await widget.storage.addJob(job);
    }
    HapticFeedback.mediumImpact();
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final Color onSurface = theme.colorScheme.onSurface;
    final Color labelColor =
        theme.textTheme.bodyMedium?.color ?? AppTheme.textSecondary;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: onSurface,
        elevation: 0,
        title: Text(
          _isEditing ? l10n.editJob : l10n.addJobTitle,
          style: TextStyle(fontWeight: FontWeight.w700, color: onSurface),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: <Widget>[
            Text(
              l10n.colorRequired,
              style: TextStyle(
                color: labelColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: _colorChoices.map((MapEntry<String, Color> e) {
                final bool sel = e.key == _selectedColorKey;
                return Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedColorKey = e.key),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: e.value,
                          boxShadow: sel
                              ? <BoxShadow>[
                                  BoxShadow(
                                    color: e.value.withValues(alpha: 0.65),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                          border: Border.all(
                            color: sel ? onSurface : Colors.transparent,
                            width: sel ? 2 : 0,
                          ),
                        ),
                        child: sel
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 22,
                              )
                            : null,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 22),
            Text(
              l10n.titleRequired,
              style: TextStyle(
                color: _AddJobPalette.label,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              style: TextStyle(color: onSurface),
              cursorColor: _AddJobPalette.accent,
              decoration: _fieldDecoration(
                hint: 'e.g., Waiter, Bartender',
                prefix: const Icon(
                  Icons.work_outline,
                  color: AppTheme.brandOrange,
                ),
              ),
              validator: _validateTitle,
            ),
            const SizedBox(height: 18),
            Text(
              l10n.employerOptional,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _employerController,
              style: TextStyle(color: onSurface),
              cursorColor: _AddJobPalette.accent,
              decoration: _fieldDecoration(
                hint: 'e.g., Restaurant Name, Company',
                prefix: const Icon(
                  Icons.business_outlined,
                  color: AppTheme.brandOrange,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l10n.hourlyRateOptional,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _hourlyController,
              style: TextStyle(color: onSurface),
              cursorColor: _AddJobPalette.accent,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: _fieldDecoration(hint: '0.00', prefix: null).copyWith(
                prefixText: '${currencySymbolFromCode(widget.currencyCode)} ',
                prefixStyle: const TextStyle(
                  color: _AddJobPalette.hint,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l10n.workDaysOptional,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: _weekdayChoices.map((MapEntry<int, String> d) {
                final bool sel = _selectedWeekdays.contains(d.key);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Material(
                      color: sel
                          ? AppTheme.brandOrange
                          : _AddJobPalette.dayUnselected,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (sel) {
                              _selectedWeekdays.remove(d.key);
                            } else {
                              _selectedWeekdays.add(d.key);
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: sel
                                ? <BoxShadow>[
                                    BoxShadow(
                                      color: AppTheme.brandOrange.withValues(
                                        alpha: 0.35,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            d.value,
                            style: TextStyle(
                              color: sel ? Colors.white : onSurface,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_outlined, color: Colors.white),
                label: Text(
                  _isEditing ? l10n.updateJob : l10n.saveJob,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.brandOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
