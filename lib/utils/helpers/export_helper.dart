import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/flight_record.dart';
import 'date_time_helper.dart';
import 'platform_file_helper.dart';

/// Handles PDF and CSV export of logbook records.
///
/// On **native** platforms the file is saved to the system temp directory
/// and the path is returned.  On **Flutter Web** the file is immediately
/// downloaded by the browser and the filename is returned instead of a path.
class ExportHelper {
  ExportHelper._();

  // ---------------------------------------------------------------------------
  // CSV
  // ---------------------------------------------------------------------------

  /// Exports flight records to a CSV file and returns the path / filename.
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
    return saveStringToTemp(
      filename ?? 'skycrew_logbook_${_timestamp()}.csv',
      csv,
    );
  }

  // ---------------------------------------------------------------------------
  // PDF
  // ---------------------------------------------------------------------------

  /// Exports flight records to a PDF file and returns the path / filename.
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
    return saveBytesToTemp(
      filename ?? 'skycrew_logbook_${_timestamp()}.pdf',
      bytes,
    );
  }

  // ---------------------------------------------------------------------------
  // Share (web: uses Web Share API if available; native: native share sheet)
  // ---------------------------------------------------------------------------

  /// Shares the exported file.  On web, falls back to a no-op when the
  /// Web Share API is not available (the browser download already handled it).
  static Future<void> shareFile(String filePath) async {
    if (kIsWeb) return; // browser download is the web share mechanism
    await Share.shareXFiles([XFile(filePath)]);
  }

  /// Opens an exported file in an external app (native only).
  /// On web this is a no-op because the file was already downloaded by the
  /// browser via [saveBytesToTemp] / [saveStringToTemp].
  static Future<void> openFile(String filePath) async {
    // open_filex is not supported on web; file is downloaded directly.
    if (kIsWeb) return;
    // On native, callers should use open_filex directly if needed.
    // Keeping this method for API compatibility.
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
        pw.Text('SkyCrew v1.0', style: const pw.TextStyle(fontSize: 9)),
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

  static String _timestamp() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}';
  }
}
