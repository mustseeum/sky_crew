// Flutter Web database factory — persists data in IndexedDB.
import 'package:sembast_web/sembast_web.dart';

/// Returns the sembast factory backed by IndexedDB (Flutter Web).
DatabaseFactory get localDatabaseFactory => databaseFactoryWeb;

/// On web, the database name is used directly as the IndexedDB store name.
Future<String> getDatabasePath(String name) async => name;
