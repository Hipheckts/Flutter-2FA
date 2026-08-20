import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Helper class to handle local storage, dynamically switching between standard
/// [SharedPreferences] and encrypted [FlutterSecureStorage] based on configuration.
class StorageHelper {
  /// Whether to use secure encrypted storage (Keychain/Keystore) to store secrets.
  final bool useSecure;
  static const _secureStorage = FlutterSecureStorage();

  /// Creates a [StorageHelper] with the configured [useSecure] flag.
  StorageHelper({required this.useSecure});

  /// Writes a string [value] to the store under the given [key].
  Future<void> writeString(String key, String value) async {
    if (useSecure) {
      await _secureStorage.write(key: key, value: value);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    }
  }

  /// Reads a string [value] from the store under the given [key].
  Future<String?> readString(String key) async {
    if (useSecure) {
      return await _secureStorage.read(key: key);
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }
  }

  /// Writes a boolean [value] to the store under the given [key].
  Future<void> writeBool(String key, bool value) async {
    if (useSecure) {
      await _secureStorage.write(key: key, value: value.toString());
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    }
  }

  /// Reads a boolean [value] from the store under the given [key].
  Future<bool> readBool(String key, {bool defaultValue = false}) async {
    if (useSecure) {
      final val = await _secureStorage.read(key: key);
      if (val == null) return defaultValue;
      return val.toLowerCase() == 'true';
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(key) ?? defaultValue;
    }
  }

  /// Serializes and saves the list of backup [codes].
  Future<void> saveRecoveryCodes(List<String> codes) async {
    final codesString = codes.join(',');
    await writeString('recoveryCodes', codesString);
  }

  /// Deserializes and retrieves the saved list of backup recovery codes.
  Future<List<String>> getRecoveryCodes() async {
    final codesString = await readString('recoveryCodes');
    if (codesString == null || codesString.isEmpty) {
      return [];
    }
    return codesString.split(',');
  }

  /// Validates a single recovery [code], and if correct, marks it as used
  /// by removing it from the stored list.
  Future<bool> useRecoveryCode(String code) async {
    final codes = await getRecoveryCodes();
    final cleanCode = code.trim().replaceAll('-', '').toLowerCase();
    
    int index = -1;
    for (int i = 0; i < codes.length; i++) {
      if (codes[i].trim().replaceAll('-', '').toLowerCase() == cleanCode) {
        index = i;
        break;
      }
    }

    if (index != -1) {
      codes.removeAt(index);
      await saveRecoveryCodes(codes);
      return true;
    }
    return false;
  }
}
