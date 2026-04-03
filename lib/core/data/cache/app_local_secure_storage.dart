import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

mixin AppLocalSecureStoreMixin {
  Future<String?> readSecure({required String key, String? defaultValue});

  Future<void> writeSecure({required String key, required String value});

  Future<void> deleteSecure(String key);

  Future<void> deleteAllSecure();

  Future<bool> containsKeySecure(String key);
}

class AppLocalSecureStorage with AppLocalSecureStoreMixin {
  AppLocalSecureStorage._();
  static final _instance = AppLocalSecureStorage._();

  factory AppLocalSecureStorage.instance() => _instance;

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  @override
  Future<String?> readSecure({
    required String key,
    String? defaultValue,
  }) async {
    try {
      final value = await _storage.read(key: key);
      return value ?? defaultValue;
    } catch (_) {
      return defaultValue;
    }
  }

  @override
  Future<void> writeSecure({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<void> deleteSecure(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAllSecure() async {
    await _storage.deleteAll();
  }

  @override
  Future<bool> containsKeySecure(String key) async {
    return _storage.containsKey(key: key);
  }

  Future<void> savePin(
    String pin, {
    String? ciphertext,
    String? cipherMethod,
  }) async {
    final salt = _generateSalt();
    final hashedPin = _hashPin(pin, salt);

    debugPrint(
      '[PIN] savePin: pinLen=${pin.length}, hasCiphertext=${ciphertext != null}, hasCipherMethod=${cipherMethod != null}',
    );
    await writeSecure(key: _pinHashKey, value: hashedPin);
    await writeSecure(key: _pinSaltKey, value: salt);

    if (ciphertext != null) {
      await writeSecure(key: _pinCiphertextKey, value: ciphertext);
    }
    if (cipherMethod != null) {
      await writeSecure(key: _pinCipherMethodKey, value: cipherMethod);
    }
  }

  Future<bool> verifyPin(String pin) async {
    debugPrint('[PIN] verifyPin(local): pinLen=${pin.length}');
    final storedHash = await readSecure(key: _pinHashKey);
    final salt = await readSecure(key: _pinSaltKey);

    if (storedHash == null || salt == null) return false;
    final matched = _hashPin(pin, salt) == storedHash;
    debugPrint(
      '[PIN] verifyPin(local): storedHashLen=${storedHash.length}, saltLen=${salt.length}, matched=$matched',
    );
    return matched;
  }

  Future<bool> hasPin() async {
    final has = await containsKeySecure(_pinHashKey);
    debugPrint('[PIN] hasPin(local): $has');
    return has;
  }

  Future<String?> getPinCiphertext() async {
    debugPrint('[PIN] getPinCiphertext(local)');
    return readSecure(key: _pinCiphertextKey);
  }

  Future<String?> getPinCipherMethod() async {
    debugPrint('[PIN] getPinCipherMethod(local)');
    return readSecure(key: _pinCipherMethodKey);
  }

  Future<void> clearPin() async {
    debugPrint('[PIN] clearPin(local)');
    await deleteSecure(_pinHashKey);
    await deleteSecure(_pinSaltKey);
    await deleteSecure(_pinCiphertextKey);
    await deleteSecure(_pinCipherMethodKey);
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await writeSecure(key: _biometricEnabledKey, value: enabled.toString());
  }

  Future<bool> isBiometricEnabled() async {
    final value = await readSecure(
      key: _biometricEnabledKey,
      defaultValue: 'false',
    );
    return value == 'true';
  }

  Future<void> clearBiometric() async {
    await deleteSecure(_biometricEnabledKey);
  }

  String _hashPin(String pin, String salt) {
    final bytes = utf8.encode(pin + salt);
    return sha256.convert(bytes).toString();
  }

  /// สร้าง salt สำหรับ hash PIN
  String _generateSalt() {
    final random = DateTime.now().microsecondsSinceEpoch.toString();
    debugPrint('[PIN] _generateSalt: random=$random');
    final salt = sha256
        .convert(utf8.encode(random))
        .toString()
        .substring(0, 32);
    debugPrint('[PIN] _generateSalt: salt=$salt');
    return salt;
  }

  static const String _pinHashKey = 'app_pin_hash';
  static const String _pinSaltKey = 'app_pin_salt';
  static const String _pinCiphertextKey = 'app_pin_ciphertext';
  static const String _pinCipherMethodKey = 'app_pin_cipher_method';
  static const String _biometricEnabledKey = 'biometric_enabled';
}
