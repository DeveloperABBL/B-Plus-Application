import 'dart:convert';

import 'package:brownyplus/core/data/cache/biometric_helper.dart';
import 'package:brownyplus/core/providers/customer_provider.dart';
import 'package:brownyplus/feature/authentication/repository/pin_biometric_repository.dart';
import 'package:brownyplus/core/utils/pin_decryption_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

enum PinBiometricPross { verify, verifyByPin }

class PinBiometricViewModel extends ChangeNotifier {
  final PinBioMetricRepository _repository;
  final PinBiometricPross process;

  /// เก็บ `laravelAppKey` ล่าสุด เพื่อใช้ decrypt ciphertext สำหรับ offline verify
  String? _laravelAppKey;

  PinBiometricViewModel({
    required PinBioMetricRepository repository,
    required this.process,
  }) : _repository = repository;

  String _pin = '';
  String get pin => _pin;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  static const int pinLength = 6;

  void addDigit(String digit, [VoidCallback? onVerified]) {
    if (_pin.length >= pinLength) return;

    _pin += digit;
    debugPrint('[PIN] addDigit: entered ${_pin.length}/$pinLength');
    _errorMessage = null;
    notifyListeners();

    if (_pin.length == pinLength) {
      debugPrint('[PIN] PIN length reached, verifying...');
      verifyPin(_pin).then((success) {
        if (success && onVerified != null) {
          onVerified();
        }
      });
    }
  }

  void removeDigit() {
    if (_pin.isNotEmpty) {
      _pin = _pin.substring(0, _pin.length - 1);
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<bool> verifyPin(String pin) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final offlineOk = await _verifyPinOffline(pin);
      bool onlineOk = false;

      // - โหมด `verify`: ใช้ผลจาก API เป็นตัวตัดสิน
      // - โหมด `verifyByPin`: ใช้ผล local/offline เป็นตัวตัดสิน แต่ยัง log online เผื่อ debug
      if (process == PinBiometricPross.verify || !offlineOk) {
        onlineOk = await _verifyPinOnline(pin);
      }

      debugPrint(
        '[PIN] verifyPin: offlineOk=$offlineOk, onlineOk=$onlineOk, process=$process',
      );

      final ok = process == PinBiometricPross.verify ? onlineOk : offlineOk;

      if (ok) {
        debugPrint('[PIN] verifyPin: success');
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'PIN ไม่ถูกต้อง';
      _pin = '';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint(
        '[PIN] verifyPin: exception=${e.runtimeType} msg=${e.toString()}',
      );
      _isLoading = false;
      _errorMessage = e.toString();
      _pin = '';
      notifyListeners();
      return false;
    }
  }

  Future<bool> _verifyPinOffline(String pin) async {
    try {
      if (!RegExp(r'^\d{6}$').hasMatch(pin)) {
        debugPrint('[PIN] _verifyPinOffline: invalid format');
        return false;
      }

      final hasHash = await _repository.requireSecureStorage.hasPin();
      debugPrint('[PIN] _verifyPinOffline: hasHashPin=$hasHash');

      // ถ้ามี hash/salt ตาม flow เดิม ให้ใช้งาน method เดิม
      if (hasHash) {
        debugPrint('[PIN] _verifyPinOffline: verify via hash+salt');
        final result = await _repository.verifyPin(pin);
        if (result.isSuccess) return result.data;
        debugPrint('[PIN] _verifyPinOffline: hash verify error=${result.error}');
        return false;
      }

      // ถ้าไม่มี hash ให้ fallback: decrypt ciphertext จาก server แล้วเทียบกับ PIN ที่ผู้ใช้กด
      final ciphertext = await _repository.requireSecureStorage.readSecure(
        key: 'app_pin_ciphertext',
      );
      final cipherMethod = await _repository.requireSecureStorage.readSecure(
        key: 'app_pin_cipher_method',
      );

      debugPrint(
        '[PIN] _verifyPinOffline: fallback decrypt. ciphertextLen=${ciphertext?.length ?? 0}, cipherMethod=$cipherMethod',
      );

      final appKey = _laravelAppKey;
      if (appKey == null || appKey.isEmpty) {
        debugPrint('[PIN] _verifyPinOffline: missing laravelAppKey');
        return false;
      }

      if (ciphertext == null || ciphertext.isEmpty) return false;

      final decrypted = PinDecryptionUtil.decryptLaravelCiphertext(
        ciphertextB64: ciphertext,
        appKey: appKey,
      );
      final expectedPin = _extractPinFromDecryptedPayload(decrypted);

      debugPrint(
        '[PIN] _verifyPinOffline: decryptedLen=${decrypted.length}, expectedPin=$expectedPin',
      );

      return expectedPin == pin;
    } catch (e) {
      debugPrint(
        '[PIN] _verifyPinOffline: exception=${e.runtimeType} msg=${e.toString()}',
      );
      return false;
    }
  }

  Future<bool> _verifyPinOnline(String pin) async {
    try {
      final customerId = AuthSession.customerId ?? '';
      if (customerId.isEmpty) {
        debugPrint('[PIN] _verifyPinOnline: missing customerId');
        return false;
      }

      debugPrint('[PIN] _verifyPinOnline: calling verify-pin pinLen=${pin.length}');
      final result = await _repository.verifyPinOnline(
        pin,
        customerId: customerId,
      );

      if (!result.isSuccess) {
        debugPrint('[PIN] _verifyPinOnline: error=${result.error}');
        return false;
      }

      return result.data;
    } catch (e) {
      debugPrint(
        '[PIN] _verifyPinOnline: exception=${e.runtimeType} msg=${e.toString()}',
      );
      return false;
    }
  }

  String? _extractPinFromDecryptedPayload(String decryptedPlain) {
    final plain = decryptedPlain.trim();

    // กรณี decrypt แล้วได้เป็นตัวเลข PIN ตรง ๆ
    if (RegExp(r'^\d{6}$').hasMatch(plain)) return plain;

    // กรณีเป็น JSON: { "pin": "123456" } หรือ { "value": ... }
    try {
      final decoded = jsonDecode(plain);
      if (decoded is Map<String, dynamic>) {
        final candidate = (decoded['pin'] ?? decoded['value'] ?? decoded['data']);
        if (candidate is String && RegExp(r'^\d{6}$').hasMatch(candidate)) {
          return candidate;
        }
      }
    } catch (_) {
      // ignore
    }

    // fallback: หาเลข 6 หลักที่โผล่ในข้อความ
    final match = RegExp(r'(\d{6})').firstMatch(plain);
    return match?.group(1);
  }

  Future<bool> getPinFromServer({required String appKey}) async {
    // เก็บ appKey ล่าสุดเพื่อใช้ decrypt สำหรับ offline verify fallback
    _laravelAppKey = appKey;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final customerId = AuthSession.customerId ?? '';
      if (customerId.isEmpty) {
        debugPrint('[PIN] getPinFromServer: missing customerId');
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final result = await _repository.getPinFromServer(customerId: customerId);
      if (!result.isSuccess) {
        final err = result.hasError ? result.error.toString() : 'n/a';
        debugPrint('[PIN] getPinFromServer: repository error=$err');
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final ciphertext = result.data['ciphertext'];
      if (ciphertext == null || ciphertext.isEmpty) {
        debugPrint('[PIN] getPinFromServer: ciphertext missing');
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final cipherMethod = result.data['cipher'];

      debugPrint(
        '[PIN] getPinFromServer: ciphertext present. ciphertextLen=${ciphertext.length}, cipherMethod=$cipherMethod',
      );

      // dump: เก็บ ciphertext/cipher ลง secure storage ไว้ให้ verify โหมด offline สามารถ decrypt ได้
      await _repository.requireSecureStorage.writeSecure(
        key: 'app_pin_ciphertext',
        value: ciphertext,
      );
      if (cipherMethod != null && cipherMethod.isNotEmpty) {
        await _repository.requireSecureStorage.writeSecure(
          key: 'app_pin_cipher_method',
          value: cipherMethod,
        );
      }

      // ถอดเพื่อหา PIN plaintext และ (ถ้าได้) เก็บ hash+salt ด้วย flow เดิม
      try {
        final decrypted = PinDecryptionUtil.decryptLaravelCiphertext(
          ciphertextB64: ciphertext,
          appKey: appKey,
        );
        final expectedPin = _extractPinFromDecryptedPayload(decrypted);

        debugPrint(
          '[PIN] getPinFromServer: decryptedLen=${decrypted.length}, expectedPin=$expectedPin',
        );

        if (expectedPin != null && RegExp(r'^\d{6}$').hasMatch(expectedPin)) {
          await _repository.requireSecureStorage.savePin(
            expectedPin,
            ciphertext: ciphertext,
            cipherMethod: cipherMethod,
          );
        } else {
          debugPrint(
            '[PIN] getPinFromServer: decrypted but cannot extract 6-digit pin.',
          );
        }
      } catch (e) {
        debugPrint(
          '[PIN] getPinFromServer: decrypt failed=${e.runtimeType} msg=${e.toString()}',
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint(
        '[PIN] getPinFromServer: exception=${e.runtimeType} msg=${e.toString()}',
      );
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _pin = '';
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> setBiometricEnabled(bool enabled) async {
    try {
      final result = await _repository.setBiometricEnabled(enabled);
      return result.isSuccess ? result.data : false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isBiometricAvailable() async {
    try {
      final result = await _repository.isBiometricAvailable();
      return result.isSuccess ? result.data : false;
    } catch (_) {
      return false;
    }
  }

  Future<BiometricAuthResult?> authenticateWithBiometric({
    String? reason,
  }) async {
    try {
      final result = await _repository.authenticateWithBiometric(
        reason: reason,
      );
      if (result.isSuccess) return result.data;
      return null;
    } catch (_) {
      return null;
    }
  }
}
