import 'dart:io';

import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/job_entry.dart';
import '../models/tip_entry.dart';
import 'pdf_table_report.dart';
import 'tip_pdf_export.dart';

Future<PdfExportResult> shareGetTipIncomeReport(
  List<TipEntry> tips,
  List<JobEntry> jobs, {
  DateTime? rangeStart,
  DateTime? rangeEnd,
  String currencySymbol = r'$',
  bool openShareSheet = true,
  List<TipEntry>? exportRows,
  String? reportTitleLine,
  bool includeBestDaySummary = true,
  String? fileNameStem,
}) async {
  final List<int> bytes = await generateGetTipIncomeReportPdf(
    tips: tips,
    jobs: jobs,
    rangeStart: rangeStart,
    rangeEnd: rangeEnd,
    currencySymbol: currencySymbol,
    exportRows: exportRows,
    reportTitleLine: reportTitleLine,
    includeBestDaySummary: includeBestDaySummary,
  );

  final String safeName = (fileNameStem != null && fileNameStem.isNotEmpty)
      ? fileNameStem
      : _reportFileStem(
          rangeStart: rangeStart,
          rangeEnd: rangeEnd,
        );
  final Directory dir = await getTemporaryDirectory();
  final File tempFile = File('${dir.path}/$safeName.pdf');
  await tempFile.writeAsBytes(bytes, flush: true);

  bool savedToDownloads = false;
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      final String? savedPath = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(
          sourceFilePath: tempFile.path,
          fileName: '$safeName.pdf',
        ),
      );
      savedToDownloads = savedPath != null;
    } else {
      final Directory? downloadsDir = await _resolveDownloadsDirectory();
      if (downloadsDir != null) {
        if (!downloadsDir.existsSync()) {
          await downloadsDir.create(recursive: true);
        }
        final File downloadsFile = File('${downloadsDir.path}/$safeName.pdf');
        await downloadsFile.writeAsBytes(bytes, flush: true);
        savedToDownloads = true;
      }
    }
    if (!savedToDownloads) {
      final Directory? downloadsDir = await _resolveDownloadsDirectory();
      if (downloadsDir != null) {
        if (!downloadsDir.existsSync()) {
          await downloadsDir.create(recursive: true);
        }
        final File downloadsFile = File('${downloadsDir.path}/$safeName.pdf');
        await downloadsFile.writeAsBytes(bytes, flush: true);
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
        final File downloadsFile = File('${downloadsDir.path}/$safeName.pdf');
        await downloadsFile.writeAsBytes(bytes, flush: true);
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
      await Share.shareXFiles(<XFile>[
        XFile(tempFile.path),
      ], subject: 'Get Tip — $safeName');
      shareOpened = true;
    } catch (_) {
      shareOpened = false;
    }
  }

  return PdfExportResult(
    savedToDownloads: savedToDownloads,
    shareOpened: shareOpened,
  );
}

String _reportFileStem({
  DateTime? rangeStart,
  DateTime? rangeEnd,
}) {
  if (rangeStart == null && rangeEnd == null) {
    return 'gettip_income_report_all_time';
  }
  String p(DateTime? d) {
    if (d == null) {
      return 'na';
    }
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  return 'gettip_income_report_${p(rangeStart)}_to_${p(rangeEnd)}';
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
