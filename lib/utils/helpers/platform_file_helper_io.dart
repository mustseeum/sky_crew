// Native implementation (Android / iOS / macOS / Windows / Linux).
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Writes [content] to the system temp directory and returns the file path.
Future<String> saveStringToTemp(String filename, String content) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$filename');
  await file.writeAsString(content);
  return file.path;
}

/// Writes [bytes] to the system temp directory and returns the file path.
Future<String> saveBytesToTemp(String filename, List<int> bytes) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes);
  return file.path;
}
