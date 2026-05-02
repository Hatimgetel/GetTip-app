import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/job_entry.dart';
import '../models/tip_entry.dart';

/// TipFlow income report — single professional table, A4, Helvetica.
///
/// [rangeStart] / [rangeEnd]: inclusive filter on tip dates (local calendar).
/// Pass both `null` for **all time**.
///
/// When [exportRows] is set, those rows are used as-is (sorted newest first);
/// [rangeStart]/[rangeEnd] and the main [tips] list are ignored for table data.
///
/// [reportTitleLine]: full first-line title (e.g. `TipFlow Report — Today`).
/// When set, the default “TipFlow / Income Report / Period” header is replaced.
///
/// [includeBestDaySummary]: when false, omits the post-table stats block (table
/// still includes the TOTAL row).
Future<List<int>> generateTipFlowIncomeReportPdf({
  required List<TipEntry> tips,
  required List<JobEntry> jobs,
  DateTime? rangeStart,
  DateTime? rangeEnd,
  String currencySymbol = r'$',
  List<TipEntry>? exportRows,
  String? reportTitleLine,
  bool includeBestDaySummary = true,
}) async {
  final PdfColor accent = PdfColor.fromHex('FF9800');
  final PdfColor headerBg = PdfColor(0.88, 0.88, 0.88);
  final PdfColor rowAlt = PdfColor(0.97, 0.97, 0.97);
  final PdfColor totalRowBg = PdfColor(1.0, 0.92, 0.80);

  final Map<String, String> jobTitleById = <String, String>{
    for (final JobEntry j in jobs) j.id: j.title,
  };

  final List<TipEntry> filtered =
      exportRows != null
          ? (List<TipEntry>.from(exportRows)..sort(
            (TipEntry a, TipEntry b) => b.date.compareTo(a.date),
          ))
          : (_filterTipsByRange(
                tips,
                rangeStart: rangeStart,
                rangeEnd: rangeEnd,
              )..sort((TipEntry a, TipEntry b) => b.date.compareTo(a.date)));

  final DateFormat dateCol = DateFormat('dd/MM/yyyy');
  final NumberFormat money = NumberFormat.currency(
    symbol: currencySymbol,
    decimalDigits: 2,
  );

  final String standardPeriodLabel = _periodLabel(
    rangeStart,
    rangeEnd,
    filtered,
  );
  final double sumAmount =
      filtered.fold<double>(0, (double s, TipEntry t) => s + t.amount);
  final int entryCount = filtered.length;
  final ({String label, double amount}) best = _bestDay(filtered, dateCol);

  final pw.Document doc = pw.Document();
  final pw.Font helvetica = pw.Font.helvetica();
  final pw.Font helveticaBold = pw.Font.helveticaBold();

  pw.TextStyle bodyStyle({
    bool bold = false,
    double size = 10,
    PdfColor color = PdfColors.black,
  }) =>
      pw.TextStyle(
        font: bold ? helveticaBold : helvetica,
        fontSize: size,
        color: color,
      );

  pw.Widget cell(
    String text, {
    bool bold = false,
    double size = 10,
    PdfColor color = PdfColors.black,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: pw.Text(
        text,
        style: bodyStyle(bold: bold, size: size, color: color),
      ),
    );
  }

  pw.TableRow headerRow() {
    return pw.TableRow(
      decoration: pw.BoxDecoration(color: headerBg),
      children: <pw.Widget>[
        cell('DATE', bold: true, size: 12),
        cell('JOB', bold: true, size: 12),
        cell('AMOUNT', bold: true, size: 12),
        cell('NOTE', bold: true, size: 12),
      ],
    );
  }

  pw.TableRow dataRow(TipEntry t, int index) {
    final PdfColor? bg = index.isEven ? null : rowAlt;
    final DateTime local = t.date.toLocal();
    final String jobLabel =
        t.jobId == null || t.jobId!.isEmpty
            ? '—'
            : (jobTitleById[t.jobId] ?? '—');
    final String noteRaw = (t.notes ?? '').trim();
    final String note =
        noteRaw.isEmpty ? '—' : _shortenNote(noteRaw, maxChars: 48);

    return pw.TableRow(
      decoration:
          bg != null ? pw.BoxDecoration(color: bg) : const pw.BoxDecoration(),
      children: <pw.Widget>[
        cell(dateCol.format(local)),
        cell(jobLabel),
        cell(money.format(t.amount)),
        cell(note),
      ],
    );
  }

  pw.TableRow totalRow() {
    return pw.TableRow(
      decoration: pw.BoxDecoration(color: totalRowBg),
      children: <pw.Widget>[
        cell('TOTAL', bold: true),
        cell(''),
        cell(money.format(sumAmount), bold: true),
        cell(''),
      ],
    );
  }

  pw.Widget tableBlock({
    required List<TipEntry> chunk,
    required bool showTotal,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: accent, width: 0.6),
      columnWidths: <int, pw.TableColumnWidth>{
        0: const pw.FlexColumnWidth(1.15),
        1: const pw.FlexColumnWidth(1.85),
        2: const pw.FlexColumnWidth(1.0),
        3: const pw.FlexColumnWidth(2.35),
      },
      children: <pw.TableRow>[
        headerRow(),
        for (int i = 0; i < chunk.length; i++) dataRow(chunk[i], i),
        if (showTotal) totalRow(),
      ],
    );
  }

  pw.Widget docHeader() {
    if (reportTitleLine != null) {
      return pw.Text(
        reportTitleLine,
        style: pw.TextStyle(
          font: helveticaBold,
          fontSize: 12,
          color: accent,
        ),
      );
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        pw.Text(
          'TipFlow',
          style: pw.TextStyle(
            font: helveticaBold,
            fontSize: 12,
            color: accent,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          'Income Report',
          style: pw.TextStyle(
            font: helveticaBold,
            fontSize: 12,
            color: PdfColors.black,
          ),
        ),
      ],
    );
  }

  pw.Widget periodBlock() {
    if (reportTitleLine != null) {
      return pw.SizedBox(height: reportTitleLine.isNotEmpty ? 8 : 0);
    }
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 10, bottom: 6),
      child: pw.Text(
        standardPeriodLabel,
        style: bodyStyle(size: 10),
      ),
    );
  }

  pw.Widget summaryBlock() {
    final String bestText =
        best.amount <= 0
            ? '—'
            : '${best.label} (${money.format(best.amount)})';
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        pw.Text(
          'Total tips: ${money.format(sumAmount)}',
          style: bodyStyle(bold: true, size: 10),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Total entries: $entryCount',
          style: bodyStyle(size: 10),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Best day: $bestText',
          style: bodyStyle(size: 10),
        ),
      ],
    );
  }

  pw.Widget footerBlock() {
    final String generated = DateFormat.yMMMMd().add_jm().format(DateTime.now());
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Text(
            'Generated: $generated',
            style: pw.TextStyle(
              font: helvetica,
              fontSize: 9,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            'TipFlow',
            style: pw.TextStyle(
              font: helvetica,
              fontSize: 9,
              color: PdfColors.grey700,
            ),
          ),
        ],
      ),
    );
  }

  if (filtered.isEmpty) {
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: <pw.Widget>[
              docHeader(),
              periodBlock(),
              tableBlock(chunk: const <TipEntry>[], showTotal: true),
              if (includeBestDaySummary) ...<pw.Widget>[
                pw.SizedBox(height: 12),
                summaryBlock(),
              ],
              pw.Spacer(),
              footerBlock(),
            ],
          );
        },
      ),
    );
    return doc.save();
  }

  final List<List<TipEntry>> chunks = _chunkTips(filtered);
  for (int i = 0; i < chunks.length; i++) {
    final bool isFirst = i == 0;
    final bool isLast = i == chunks.length - 1;
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: <pw.Widget>[
              if (isFirst) ...<pw.Widget>[
                docHeader(),
                periodBlock(),
              ] else
                pw.SizedBox(height: 4),
              tableBlock(chunk: chunks[i], showTotal: isLast),
              if (isLast) ...<pw.Widget>[
                if (includeBestDaySummary) ...<pw.Widget>[
                  pw.SizedBox(height: 12),
                  summaryBlock(),
                ],
                pw.Spacer(),
                footerBlock(),
              ],
            ],
          );
        },
      ),
    );
  }

  return doc.save();
}

List<TipEntry> _filterTipsByRange(
  List<TipEntry> tips, {
  DateTime? rangeStart,
  DateTime? rangeEnd,
}) {
  if (rangeStart == null && rangeEnd == null) {
    return List<TipEntry>.from(tips);
  }
  final DateTime? start =
      rangeStart == null
          ? null
          : DateTime(rangeStart.year, rangeStart.month, rangeStart.day);
  final DateTime? end =
      rangeEnd == null
          ? null
          : DateTime(
            rangeEnd.year,
            rangeEnd.month,
            rangeEnd.day,
            23,
            59,
            59,
            999,
          );

  return tips.where((TipEntry t) {
    final DateTime d = t.date.toLocal();
    if (start != null && d.isBefore(start)) {
      return false;
    }
    if (end != null && d.isAfter(end)) {
      return false;
    }
    return true;
  }).toList();
}

String _periodLabel(
  DateTime? rangeStart,
  DateTime? rangeEnd,
  List<TipEntry> filtered,
) {
  if (rangeStart == null && rangeEnd == null) {
    return 'Period: All time';
  }
  final DateFormat f = DateFormat('dd/MM/yyyy');
  final String a =
      rangeStart != null
          ? f.format(
            DateTime(
              rangeStart.year,
              rangeStart.month,
              rangeStart.day,
            ),
          )
          : '—';
  final String b =
      rangeEnd != null
          ? f.format(
            DateTime(rangeEnd.year, rangeEnd.month, rangeEnd.day),
          )
          : '—';
  return 'Period: $a – $b';
}

({String label, double amount}) _bestDay(
  List<TipEntry> tips,
  DateFormat dayKeyFormat,
) {
  if (tips.isEmpty) {
    return (label: '—', amount: 0);
  }
  final Map<String, double> byDay = <String, double>{};
  for (final TipEntry t in tips) {
    final String key = dayKeyFormat.format(t.date.toLocal());
    byDay[key] = (byDay[key] ?? 0) + t.amount;
  }
  String bestKey = '';
  double bestAmt = 0;
  byDay.forEach((String k, double v) {
    if (v > bestAmt) {
      bestAmt = v;
      bestKey = k;
    }
  });
  return (label: bestKey.isEmpty ? '—' : bestKey, amount: bestAmt);
}

String _shortenNote(String s, {required int maxChars}) {
  if (s.length <= maxChars) return s;
  return '${s.substring(0, math.max(0, maxChars - 1))}…';
}

/// Split rows so header + chunk fits comfortably on A4 with top matter on page 1.
List<List<TipEntry>> _chunkTips(List<TipEntry> filtered) {
  const int firstPage = 22;
  const int otherPages = 30;
  if (filtered.length <= firstPage) {
    return <List<TipEntry>>[filtered];
  }
  final List<List<TipEntry>> out = <List<TipEntry>>[
    filtered.sublist(0, firstPage),
  ];
  int i = firstPage;
  while (i < filtered.length) {
    final int end = math.min(i + otherPages, filtered.length);
    out.add(filtered.sublist(i, end));
    i = end;
  }
  return out;
}
