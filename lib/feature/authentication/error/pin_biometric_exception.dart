import 'package:flutter/widgets.dart';

sealed class PinExceptions implements Exception {
  final String? message;

  PinExceptions([this.message]);

  String toUiMessage(BuildContext context) {
    return message ?? 'เกิดข้อผิดพลาด';
  }
}

class InvalidPinFormat extends PinExceptions {
  InvalidPinFormat([super.message]);

  @override
  String toUiMessage(BuildContext context) => 'PIN ต้องเป็นตัวเลข 6 หลัก';
}

class ValidationPinError extends PinExceptions {
  ValidationPinError([super.message]);

  @override
  String toUiMessage(BuildContext context) => message ?? 'ข้อมูล PIN ไม่ถูกต้อง';
}

sealed class BiometricExceptions implements Exception {
  final String? message;

  BiometricExceptions([this.message]);

  String toUiMessage(BuildContext context) {
    return message ?? 'เกิดข้อผิดพลาด';
  }
}

class BiometricNotAvailable extends BiometricExceptions {
  BiometricNotAvailable([super.message]);
}

class BiometricNotEnrolled extends BiometricExceptions {
  BiometricNotEnrolled([super.message]);
}

class BiometricUserCanceled extends BiometricExceptions {
  BiometricUserCanceled([super.message]);
}

class BiometricLockedOut extends BiometricExceptions {
  BiometricLockedOut([super.message]);
}

class BiometricPermanentlyLockedOut extends BiometricExceptions {
  BiometricPermanentlyLockedOut([super.message]);
}

class BiometricAuthFailed extends BiometricExceptions {
  BiometricAuthFailed([super.message]);
}

class BiometricNotEnabled extends BiometricExceptions {
  BiometricNotEnabled([super.message]);
}

class BiometricRequiresPin extends BiometricExceptions {
  BiometricRequiresPin([super.message]);
}
