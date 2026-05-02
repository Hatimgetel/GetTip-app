import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/quick_add_settings_service.dart';
import '../theme/app_theme.dart';
import 'top_message.dart';

/// Returns `true` if the user saved, `false` if cancelled, `null` if context unmounted.
Future<bool?> showQuickAddCustomizeDialog({
  required BuildContext context,
  required QuickAddSettingsService service,
}) async {
  final List<double> values = await service.loadValues();
  final List<String> notes = await service.loadNotes();
  if (!context.mounted) return null;

  final TextEditingController value1 = TextEditingController(
    text: values[0].toStringAsFixed(values[0] == values[0].roundToDouble() ? 0 : 2),
  );
  final TextEditingController value2 = TextEditingController(
    text: values[1].toStringAsFixed(values[1] == values[1].roundToDouble() ? 0 : 2),
  );
  final TextEditingController value3 = TextEditingController(
    text: values[2].toStringAsFixed(values[2] == values[2].roundToDouble() ? 0 : 2),
  );
  final TextEditingController note1 = TextEditingController(text: notes[0]);
  final TextEditingController note2 = TextEditingController(text: notes[1]);
  final TextEditingController note3 = TextEditingController(text: notes[2]);

  final bool? shouldSave = await showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      final ThemeData theme = Theme.of(dialogContext);
      final AppLocalizations l10n = AppLocalizations.of(dialogContext)!;
      return AlertDialog(
        backgroundColor: theme.cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: theme.dividerColor),
        ),
        title: Text(l10n.customizeQuickButtonsTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.tipNumberLabel(1),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: value1,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.amountLabel,
                  prefixText: r'$ ',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: note1,
                decoration: InputDecoration(labelText: l10n.noteUnderTipLabel),
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.tipNumberLabel(2),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: value2,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.amountLabel,
                  prefixText: r'$ ',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: note2,
                decoration: InputDecoration(labelText: l10n.noteUnderTipLabel),
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.tipNumberLabel(3),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: value3,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.amountLabel,
                  prefixText: r'$ ',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: note3,
                decoration: InputDecoration(labelText: l10n.noteUnderTipLabel),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              value1.text = '10';
              value2.text = '20';
              value3.text = '50';
              note1.text = '';
              note2.text = '';
              note3.text = '';
            },
            child: Text(
              l10n.reset,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              l10n.cancel,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.brandOrange,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final List<double?> parsed = <double?>[
                double.tryParse(value1.text.trim()),
                double.tryParse(value2.text.trim()),
                double.tryParse(value3.text.trim()),
              ];
              final bool hasInvalid = parsed.any(
                (double? n) => n == null || n <= 0,
              );
              if (hasInvalid) {
                showTopMessage(
                  context,
                  message: l10n.invalidAmounts,
                );
                return;
              }
              Navigator.of(dialogContext).pop(true);
            },
            child: Text(l10n.save),
          ),
        ],
      );
    },
  );

  if (shouldSave != true) return false;

  final double parsed1 = double.parse(value1.text.trim());
  final double parsed2 = double.parse(value2.text.trim());
  final double parsed3 = double.parse(value3.text.trim());
  await service.saveValues(<double>[
    parsed1,
    parsed2,
    parsed3,
  ]);
  await service.saveNotes(<String>[
    note1.text,
    note2.text,
    note3.text,
  ]);
  return true;
}
