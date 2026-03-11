import 'package:shared_preferences/shared_preferences.dart';

/// Simple key-value local data source using SharedPreferences.
class HiveLocalDatasource {
  const HiveLocalDatasource(this._prefs);

  final SharedPreferences _prefs;

  Future<void> write(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? read(String key) {
    return _prefs.getString(key);
  }

  Future<void> delete(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }

  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}
