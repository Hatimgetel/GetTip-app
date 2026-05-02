import '../models/job_entry.dart';
import '../models/tip_entry.dart';
import 'tip_pdf_export.dart';

Future<PdfExportResult> shareTipFlowIncomeReport(
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
}) async => const PdfExportResult(savedToDownloads: false, shareOpened: false);
