import 'package:flutter/material.dart';

import '../models/job_entry.dart';
import '../models/tip_entry.dart';
import '../screens/add_entry_screen.dart';
import '../services/storage_service.dart';

/// Long-press menu: edit tip (full screen) or delete (with confirmation, uses [onDeleteWithUndo]).
Future<void> showTipEntryActions(
  BuildContext context, {
  required TipEntry entry,
  required StorageService storage,
  required List<JobEntry> jobs,
  required String currencyCode,
  required bool roundUpEnabled,
  required Future<void> Function() onTipsMutated,
  required Future<void> Function(TipEntry tip) onDeleteWithUndo,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (BuildContext sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit tip'),
              onTap: () async {
                Navigator.of(sheetContext).pop();
                await Navigator.of(context).push<bool>(
                  MaterialPageRoute<bool>(
                    builder: (BuildContext _) => AddEntryScreen(
                      storage: storage,
                      existingTip: entry,
                      currencyCode: currencyCode,
                      roundUpEnabled: roundUpEnabled,
                      jobs: jobs,
                      initialJobId: entry.jobId,
                    ),
                  ),
                );
                if (context.mounted) {
                  await onTipsMutated();
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: Colors.red.shade700),
              title: Text(
                'Delete tip',
                style: TextStyle(color: Colors.red.shade700),
              ),
              onTap: () async {
                Navigator.of(sheetContext).pop();
                final bool? confirmed = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Delete this tip?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
                if (confirmed == true && context.mounted) {
                  await onDeleteWithUndo(entry);
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
