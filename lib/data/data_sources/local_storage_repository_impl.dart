import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl implements LocalStorageRepository {
  /// save string value
  @override
  Future<void> saveStringValue(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }

  /// get string value
  @override
  Future<String> getStringValue(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(key) ?? "";
  }

  /// save bool value
  @override
  Future<void> saveBoolValue(String key, bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
  }

  /// get bool value
  @override
  Future<bool> getBoolValue(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key) ?? false;
  }

  /// save int value
  @override
  Future<void> saveIntValue(String key, int value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(key, value);
  }

  /// get int value
  @override
  Future<int> getIntValue(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(key) ?? -1;
  }

  /// remove value
  @override
  Future<bool> removeValue(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.remove(key);
  }
}