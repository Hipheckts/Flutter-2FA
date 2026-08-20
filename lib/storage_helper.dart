import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  final bool useSecure;
  static const _secureStorage = FlutterSecureStorage();

  StorageHelper({required this.useSecure});

  Future<void> writeString(String key, String value) async {
    if (useSecure) {
      await _secureStorage.write(key: key, value: value);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    }
  }

  Future<String?> readString(String key) async {
    if (useSecure) {
      return await _secureStorage.read(key: key);
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }
  }

  Future<void> writeBool(String key, bool value) async {
    if (useSecure) {
      await _secureStorage.write(key: key, value: value.toString());
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    }
  }

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

  Future<void> saveRecoveryCodes(List<String> codes) async {
    final codesString = codes.join(',');
    await writeString('recoveryCodes', codesString);
  }

  Future<List<String>> getRecoveryCodes() async {
    final codesString = await readString('recoveryCodes');
    if (codesString == null || codesString.isEmpty) {
      return [];
    }
    return codesString.split(',');
  }

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
