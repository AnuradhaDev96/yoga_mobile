abstract class LocalStorageRepository {
  /// save string value
  Future<void> saveStringValue(String key, String value);

  /// get string value
  Future<String> getStringValue(String key);

  /// save bool value
  Future<void> saveBoolValue(String key, bool value);

  /// get bool value
  Future<bool> getBoolValue(String key);

  /// save int value
  Future<void> saveIntValue(String key, int value);

  /// get int value
  Future<int> getIntValue(String key);

  /// remove value
  Future<bool> removeValue(String key);
}
