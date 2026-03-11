// Conditional export: on Flutter Web, uses dart:html for browser downloads;
// on native, uses dart:io to write files to the temp directory.
export 'platform_file_helper_io.dart'
    if (dart.library.html) 'platform_file_helper_web.dart';
