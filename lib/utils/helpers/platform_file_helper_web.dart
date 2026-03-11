// Flutter Web implementation — triggers a browser download instead of
// writing to a local file (which is unavailable in a browser sandbox).
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Encodes [content] as UTF-8 bytes and triggers a browser download.
/// Returns the [filename] (no file-system path exists on web).
Future<String> saveStringToTemp(String filename, String content) async {
  final bytes = html.Blob([content], 'text/plain;charset=utf-8');
  _triggerDownload(filename, bytes);
  return filename;
}

/// Triggers a browser download of the raw [bytes] and returns the [filename].
Future<String> saveBytesToTemp(String filename, List<int> bytes) async {
  final blob = html.Blob([bytes]);
  _triggerDownload(filename, blob);
  return filename;
}

void _triggerDownload(String filename, html.Blob blob) {
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..download = filename
    ..style.display = 'none';
  html.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);
}
