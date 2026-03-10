import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/flight_record.dart';
import 'date_time_helper.dart';

/// Handles PDF and CSV export of logbook records.
class ExportHelper {
  ExportHelper._();

  // ---------------------------------------------------------------------------
  // CSV
  // ---------------------------------------------------------------------------

  /// Exports flight records to a CSV file.
  static Future<String> exportToCSV(
    List<FlightRecord> records, {
    String? filename,
  }) async {
    final rows = <List<dynamic>>[
      [
        'Date',
        'Flight #',
        'From',
        'To',
        'Aircraft Type',
        'Reg.',
        'Block Time',
        'Duty Time',
        'Landings',
        'Night Time',
        'Role',
        'Remarks',
      ],
      ...records.map((r) => [
            DateTimeHelper.formatShortDate(r.date),
            r.flightNumber,
            r.departureAirport,
            r.arrivalAirport,
            r.aircraftType,
            r.aircraftRegistration,
            DateTimeHelper.formatMinutes(r.blockTimeMinutes),
            DateTimeHelper.formatMinutes(r.dutyTimeMinutes),
            r.landings,
            DateTimeHelper.formatMinutes(r.nightTimeMinutes),
            r.role,
            r.remarks ?? '',
          ]),
    ];

    final csv = const ListToCsvConverter().convert(rows);
    final path = await _saveToTemp(
      filename ?? 'skycrew_logbook_${_timestamp()}.csv',
      csv,
    );
    return path;
  }

  // ---------------------------------------------------------------------------
  // PDF
  // ---------------------------------------------------------------------------

  /// Exports flight records to a PDF file.
  static Future<String> exportToPDF(
    List<FlightRecord> records, {
    String? filename,
    String crewName = '',
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        header: (context) => _buildPdfHeader(crewName),
        build: (context) => [_buildPdfTable(records)],
        footer: (context) => _buildPdfFooter(context),
      ),
    );

    final bytes = await pdf.save();
    final path = await _saveBytesToTemp(
      filename ?? 'skycrew_logbook_${_timestamp()}.pdf',
      bytes,
    );
    return path;
  }

  // ---------------------------------------------------------------------------
  // Share
  // ---------------------------------------------------------------------------

  static Future<void> shareFile(String filePath) async {
    await Share.shareXFiles([XFile(filePath)]);
  }

  static Future<void> openFile(String filePath) async {
    await OpenFilex.open(filePath);
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  static pw.Widget _buildPdfHeader(String name) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'SkyCrew — Digital Logbook',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        if (name.isNotEmpty)
          pw.Text('Crew: $name', style: const pw.TextStyle(fontSize: 12)),
        pw.Text(
          'Generated: ${DateTimeHelper.formatDateTime(DateTime.now())}',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.Divider(),
      ],
    );
  }

  static pw.Widget _buildPdfFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'SkyCrew v1.0',
          style: const pw.TextStyle(fontSize: 9),
        ),
        pw.Text(
          'Page ${context.pageNumber} of ${context.pagesCount}',
          style: const pw.TextStyle(fontSize: 9),
        ),
      ],
    );
  }

  static pw.Widget _buildPdfTable(List<FlightRecord> records) {
    const headers = [
      'Date',
      'Flt #',
      'From',
      'To',
      'Aircraft',
      'Block',
      'Duty',
      'Ldg',
      'Role',
    ];

    return pw.Table.fromTextArray(
      headers: headers,
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 9,
      ),
      cellStyle: const pw.TextStyle(fontSize: 8),
      data: records.map((r) {
        return [
          DateTimeHelper.formatShortDate(r.date),
          r.flightNumber,
          r.departureAirport,
          r.arrivalAirport,
          '${r.aircraftType} ${r.aircraftRegistration}',
          DateTimeHelper.formatMinutes(r.blockTimeMinutes),
          DateTimeHelper.formatMinutes(r.dutyTimeMinutes),
          r.landings.toString(),
          r.role,
        ];
      }).toList(),
      border: pw.TableBorder.all(width: 0.5),
    );
  }

  static Future<String> _saveToTemp(String filename, String content) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsString(content);
    return file.path;
  }

  static Future<String> _saveBytesToTemp(
    String filename,
    Uint8List bytes,
  ) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  static String _timestamp() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
  }
}
