import 'tip_pdf_export_stub.dart'
    if (dart.library.io) 'tip_pdf_export_io.dart'
    as tip_pdf_impl;

import '../models/job_entry.dart';
import '../models/tip_entry.dart';

class PdfExportResult {
  const PdfExportResult({
    required this.savedToDownloads,
    required this.shareOpened,
  });

  final bool savedToDownloads;
  final bool shareOpened;
}

/// Get Tip table-only income report (A4). [rangeStart]/[rangeEnd] null = all time.
/// Default PDF document title / branding: **Get Tip Report** (see [reportTitleLine]).
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
}) => tip_pdf_impl.shareGetTipIncomeReport(
  tips,
  jobs,
  rangeStart: rangeStart,
  rangeEnd: rangeEnd,
  currencySymbol: currencySymbol,
  openShareSheet: openShareSheet,
  exportRows: exportRows,
  reportTitleLine: reportTitleLine,
  includeBestDaySummary: includeBestDaySummary,
  fileNameStem: fileNameStem,
);
