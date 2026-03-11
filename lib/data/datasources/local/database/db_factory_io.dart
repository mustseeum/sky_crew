// Native (Android / iOS / macOS / Linux / Windows) database factory.
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

/// Returns the sembast factory for the current native platform.
DatabaseFactory get localDatabaseFactory => databaseFactoryIo;

/// Resolves the full file-system path for the named database.
Future<String> getDatabasePath(String name) async {
  final dir = await getApplicationDocumentsDirectory();
  return p.join(dir.path, name);
}
