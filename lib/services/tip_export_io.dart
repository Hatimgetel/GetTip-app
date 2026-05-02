import 'dart:io';

import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'tip_export.dart';

Future<CsvExportResult> exportTipsCsv(
  String csv, {
  bool openShareSheet = true,
}) async {
  final Directory tempDir = await getApplicationDocumentsDirectory();
  final String name =
      'get_tip_tips_${DateTime.now().millisecondsSinceEpoch}.csv';
  final File tempFile = File('${tempDir.path}/$name');
  await tempFile.writeAsString(csv, flush: true);

  bool savedToDownloads = false;
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      final String? savedPath = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(sourceFilePath: tempFile.path, fileName: name),
      );
      savedToDownloads = savedPath != null;
    } else {
      final Directory? downloadsDir = await _resolveDownloadsDirectory();
      if (downloadsDir != null) {
        if (!downloadsDir.existsSync()) {
          await downloadsDir.create(recursive: true);
        }
        final File downloadsFile = File('${downloadsDir.path}/$name');
        await downloadsFile.writeAsString(csv, flush: true);
        savedToDownloads = true;
      }
    }
    if (!savedToDownloads) {
      final Directory? downloadsDir = await _resolveDownloadsDirectory();
      if (downloadsDir != null) {
        if (!downloadsDir.existsSync()) {
          await downloadsDir.create(recursive: true);
        }
        final File downloadsFile = File('${downloadsDir.path}/$name');
        await downloadsFile.writeAsString(csv, flush: true);
        savedToDownloads = true;
      } else {
        savedToDownloads = false;
      }
    }
  } catch (_) {
    try {
      final Directory? downloadsDir = await _resolveDownloadsDirectory();
      if (downloadsDir != null) {
        if (!downloadsDir.existsSync()) {
          await downloadsDir.create(recursive: true);
        }
        final File downloadsFile = File('${downloadsDir.path}/$name');
        await downloadsFile.writeAsString(csv, flush: true);
        savedToDownloads = true;
      } else {
        savedToDownloads = false;
      }
    } catch (_) {
      savedToDownloads = false;
    }
  }

  bool shareOpened = false;
  if (openShareSheet) {
    try {
      await Share.shareXFiles(
        <XFile>[XFile(tempFile.path)],
        text: 'Get Tip CSV export',
        subject: 'Get Tip Export',
      );
      shareOpened = true;
    } catch (_) {
      shareOpened = false;
    }
  }

  return CsvExportResult(
    savedToDownloads: savedToDownloads,
    shareOpened: shareOpened,
  );
}

Future<Directory?> _resolveDownloadsDirectory() async {
  final Directory? providerDownloads = await getDownloadsDirectory();
  if (providerDownloads != null) {
    return providerDownloads;
  }
  if (Platform.isAndroid) {
    final Directory hardcoded = Directory('/storage/emulated/0/Download');
    if (hardcoded.existsSync()) {
      return hardcoded;
    }
    final Directory? external = await getExternalStorageDirectory();
    if (external != null) {
      return external;
    }
  }
  if (Platform.isIOS) {
    return getApplicationDocumentsDirectory();
  }
  return null;
}
