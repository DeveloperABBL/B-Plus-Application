import 'package:brownyplus/feature/authentication/error/pin_biometric_exception.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

mixin BiometricHelperMixin {
  Future<bool> canCheckBiometrics();

  Future<bool> isBiometricAvailable();

  Future<List<BiometricType>> getAvailableBiometrics();

  Future<BiometricAuthResult> authenticateWithBiometric({
    String localizedReason = 'กรุณายืนยันตัวตนเพื่อดำเนินการต่อ',
    bool useErrorDialogs = true,
    bool stickyAuth = true,
  });

  Future<bool> hasStrongBiometric();
}

class BiometricAuthResult {
  final bool isSuccess;
  final BiometricExceptions? exception;

  const BiometricAuthResult({
    required this.isSuccess,
    this.exception,
  });

  factory BiometricAuthResult.success() =>
      const BiometricAuthResult(isSuccess: true);

  factory BiometricAuthResult.failure(BiometricExceptions exception) =>
      BiometricAuthResult(
        isSuccess: false,
        exception: exception,
      );
}

class BiometricHelper with BiometricHelperMixin {
  static BiometricHelper? _instance;
  final LocalAuthentication _localAuth;

  BiometricHelper._({LocalAuthentication? localAuth})
    : _localAuth = localAuth ?? LocalAuthentication();

  factory BiometricHelper.instance({LocalAuthentication? localAuth}) {
    _instance ??= BiometricHelper._(localAuth: localAuth);
    return _instance!;
  }

  @override
  Future<bool> canCheckBiometrics() async {
    try {
      return _localAuth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> isBiometricAvailable() async {
    final canCheck = await canCheckBiometrics();
    if (!canCheck) return false;
    final availableBiometrics = await getAvailableBiometrics();
    return availableBiometrics.isNotEmpty;
  }

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return _localAuth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<BiometricAuthResult> authenticateWithBiometric({
    String localizedReason = 'กรุณายืนยันตัวตนเพื่อดำเนินการต่อ',
    bool useErrorDialogs = true,
    bool stickyAuth = true,
  }) async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        return BiometricAuthResult.failure(BiometricNotAvailable());
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: stickyAuth,
          useErrorDialogs: useErrorDialogs,
        ),
      );

      if (didAuthenticate) {
        return BiometricAuthResult.success();
      }
      return BiometricAuthResult.failure(BiometricAuthFailed());
    } on PlatformException catch (e) {
      return _handlePlatformException(e);
    } catch (e) {
      return BiometricAuthResult.failure(BiometricAuthFailed(e.toString()));
    }
  }

  @override
  Future<bool> hasStrongBiometric() async {
    try {
      final availableBiometrics = await getAvailableBiometrics();
      return availableBiometrics.any((type) {
        return type == BiometricType.face ||
            type == BiometricType.fingerprint ||
            type == BiometricType.iris;
      });
    } catch (_) {
      return false;
    }
  }

  BiometricAuthResult _handlePlatformException(PlatformException e) {
    switch (e.code) {
      case 'NotAvailable':
      case 'notAvailable':
        return BiometricAuthResult.failure(BiometricNotAvailable(e.message));
      case 'NotEnrolled':
      case 'notEnrolled':
        return BiometricAuthResult.failure(BiometricNotEnrolled(e.message));
      case 'LockedOut':
      case 'lockedOut':
        return BiometricAuthResult.failure(BiometricLockedOut(e.message));
      case 'PermanentlyLockedOut':
      case 'permanentlyLockedOut':
        return BiometricAuthResult.failure(
          BiometricPermanentlyLockedOut(e.message),
        );
      case 'UserCanceled':
      case 'GestureRejected':
        return BiometricAuthResult.failure(BiometricUserCanceled(e.message));
      default:
        return BiometricAuthResult.failure(
          BiometricAuthFailed(e.message ?? e.code),
        );
    }
  }
}
