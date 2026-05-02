import 'tip_export.dart';

Future<CsvExportResult> exportTipsCsv(
  String csv, {
  bool openShareSheet = true,
}) async => const CsvExportResult(savedToDownloads: false, shareOpened: false);
