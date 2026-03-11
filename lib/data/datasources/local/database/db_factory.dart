// Conditional export: selects the native implementation on mobile/desktop
// and the web implementation on Flutter Web.
export 'db_factory_io.dart' if (dart.library.html) 'db_factory_web.dart';
