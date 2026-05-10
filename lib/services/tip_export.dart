import 'tip_export_stub.dart' if (dart.library.io) 'tip_export_io.dart'
    as tip_export_impl;

/// CSV export uses filename `gettip_export.csv` on IO (see [tip_export_io.dart]).
class CsvExportResult {
  const CsvExportResult({
    required this.savedToDownloads,
    required this.shareOpened,
  });

  final bool savedToDownloads;
  final bool shareOpened;
}

Future<CsvExportResult> exportTipsCsv(
  String csv, {
  bool openShareSheet = true,
}) => tip_export_impl.exportTipsCsv(csv, openShareSheet: openShareSheet);
