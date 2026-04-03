import 'package:brownyplus/core/data/cache/biometric_helper.dart';
import 'package:brownyplus/core/data/remote/models/request/pin_request.dart';
import 'package:brownyplus/core/data/repo/app_repository.dart';
import 'package:brownyplus/core/utils/repo_result.dart';
import 'package:brownyplus/feature/authentication/error/pin_biometric_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// สัญญา (contract) สำหรับการทำงานของ PIN + Biometric ในชั้น Repository
/// ใช้เพื่อให้ ViewModel เรียกใช้งานผ่าน interface เดียวกัน
mixin PinBiometricDataSourceMixin {
  /// ตรวจสอบ PIN แบบ offline ด้วย hash+salt ใน local secure storage
  Future<RepoResult<bool>> verifyPin(String pin);

  /// ตรวจสอบ PIN แบบ online กับ backend โดยระบุ customerId ชัดเจน
  Future<RepoResult<bool>> verifyPinOnline(
    String pin, {
    required String customerId,
  });

  /// ตรวจสอบว่า local secure storage มี PIN ที่ sync ไว้หรือไม่
  Future<RepoResult<bool>> hasPin();

  /// ดึงข้อมูล PIN ที่เข้ารหัสจาก server
  /// คืนค่า map เช่น {ciphertext, cipher}
  Future<RepoResult<Map<String, String?>>> getPinFromServer({
    required String customerId,
  });

  /// ล้าง PIN ที่เก็บในเครื่อง
  Future<RepoResult<bool>> clearPin();

  /// เปิด/ปิดการใช้งาน biometric ใน local secure storage
  Future<RepoResult<bool>> setBiometricEnabled(bool enabled);

  /// อ่านสถานะว่าเปิด biometric แล้วหรือยัง
  Future<RepoResult<bool>> isBiometricEnabled();

  /// ล้างค่า biometric setting ใน local secure storage
  Future<RepoResult<bool>> clearBiometric();

  /// ตรวจสอบว่าอุปกรณ์รองรับ biometric หรือไม่
  Future<RepoResult<bool>> isBiometricAvailable();

  /// เรียก biometric authentication โดยตรวจ precondition ก่อน
  Future<RepoResult<BiometricAuthResult>> authenticateWithBiometric({
    String? reason,
  });

  /// ตรวจสอบว่ามี strong biometric หรือไม่ (face/fingerprint/iris)
  Future<RepoResult<bool>> hasStrongBiometric();
}

/// Repository หลักสำหรับ flow verify PIN และ biometric
class PinBioMetricRepository extends AppRepository
    with PinBiometricDataSourceMixin {
  final BiometricHelper _biometricHelper;

  PinBioMetricRepository({BiometricHelper? biometricHelper})
    : _biometricHelper = biometricHelper ?? BiometricHelper.instance();

  @override
  /// ตรวจ PIN แบบ offline ด้วย hash+salt ที่เก็บใน secure storage
  Future<RepoResult<bool>> verifyPin(String pin) async {
    try {
      // ตรวจรูปแบบ PIN ก่อน (6 หลัก ตัวเลขเท่านั้น)
      if (!_isValidPin(pin)) {
        return RepoResult.error(error: InvalidPinFormat());
      }

      final isValid = await requireSecureStorage.verifyPin(pin);
      return RepoResult.success(data: isValid);
    } catch (e) {
      return RepoResult.error(error: Exception(e.toString()));
    }
  }

  @override
  /// ตรวจ PIN กับ API `/verify-pin`
  /// พฤติกรรมสอดคล้องต้นแบบ:
  /// - 200 => true
  /// - 401 => false (PIN ไม่ถูกต้อง)
  /// - 422 => validation error
  Future<RepoResult<bool>> verifyPinOnline(
    String pin, {
    required String customerId,
  }) async {
    try {
      debugPrint(
        '[PIN] verifyPinOnline: pinLen=${pin.length}, customerIdEmpty=${customerId.isEmpty}',
      );
      // ตรวจรูปแบบ PIN ก่อนยิง API
      if (!_isValidPin(pin)) {
        debugPrint('[PIN] verifyPinOnline: invalid PIN format');
        return RepoResult.error(error: InvalidPinFormat());
      }
      // customerId ต้องมีเสมอ
      if (customerId.isEmpty) {
        debugPrint('[PIN] verifyPinOnline: missing customerId');
        return RepoResult.error(error: Exception('Customer ID is required'));
      }

      final response = await requireRemote.verifyPin(
        PinRequest(customerId: customerId, pin: pin),
      );
      if (response.response.statusCode == 422) {
        debugPrint('[PIN] verifyPinOnline: status=422 validation');
        return RepoResult.error(
          error: ValidationPinError(
            response.data.message ?? 'Invalid PIN format',
          ),
        );
      }

      if (response.response.statusCode == 401) {
        debugPrint('[PIN] verifyPinOnline: status=401 invalid PIN');
        return RepoResult.success(data: false);
      }

      // success flag จาก backend
      if (response.data.success == true) {
        debugPrint('[PIN] verifyPinOnline: backend success');
        return RepoResult.success(data: true);
      }

      debugPrint('[PIN] verifyPinOnline: backend returned success=false');
      return RepoResult.error(error: Exception('Unknown error occurred'));
    } on DioException catch (e) {
      // fallback กรณี dio throw ก่อนถึงบล็อก status ด้านบน
      final statusCode = e.response?.statusCode;
      debugPrint(
        '[PIN] verifyPinOnline: DioException status=$statusCode msg=${e.message}',
      );
      if (statusCode == 401) {
        return RepoResult.success(data: false);
      }
      if (statusCode == 422) {
        final message = e.response?.data is Map<String, dynamic>
            ? (e.response?.data['message']?.toString() ?? 'Invalid PIN format')
            : 'Invalid PIN format';
        return RepoResult.error(error: ValidationPinError(message));
      }
      return RepoResult.error(error: Exception(e.toString()));
    } catch (e) {
      debugPrint(
        '[PIN] verifyPinOnline: exception=${e.runtimeType} msg=${e.toString()}',
      );
      return RepoResult.error(error: Exception(e.toString()));
    }
  }

  @override
  /// เช็คว่ามี PIN ที่ถูกเก็บใน secure storage แล้วหรือไม่
  Future<RepoResult<bool>> hasPin() async {
    try {
      final hasPinValue = await requireSecureStorage.hasPin();
      return RepoResult.success(data: hasPinValue);
    } catch (e) {
      return RepoResult.error(error: Exception(e.toString()));
    }
  }

  @override
  /// ดึง PIN ciphertext จาก server เพื่อใช้ sync เข้า local
  Future<RepoResult<Map<String, String?>>> getPinFromServer({
    required String customerId,
  }) async {
    try {
      if (customerId.isEmpty) {
        return RepoResult.error(error: Exception('Customer ID is required'));
      }

      debugPrint('[PIN] getPinFromServer(repo): calling API');
      final response = await requireRemote.getPin(customerId);
      if (!response.data.success) {
        return RepoResult.error(
          error: Exception('Failed to get PIN from server'),
        );
      }

      debugPrint(
        '[PIN] getPinFromServer(repo): ciphertextPresent=${(response.data.ciphertext ?? '').isNotEmpty}',
      );
      return RepoResult.success(
        data: {
          // ciphertext ที่เข้ารหัสโดย backend
          'ciphertext': response.data.ciphertext,
          // cipher method ของ payload
          'cipher': response.data.cipher,
        },
      );
    } on DioException catch (e) {
      // ถ้าไม่พบ PIN บน server ให้ถือว่าไม่มีข้อมูล (ไม่ใช่ error ระบบ)
      if (e.response?.statusCode == 404) {
        return RepoResult.success(data: {'ciphertext': null, 'cipher': null});
      }
      return RepoResult.error(error: Exception(e.toString()));
    } catch (e) {
      return RepoResult.error(error: Exception(e.toString()));
    }
  }

  @override
  /// ล้างข้อมูล PIN ใน local storage
  Future<RepoResult<bool>> clearPin() async {
    try {
      await requireSecureStorage.clearPin();
      return RepoResult.success(data: true);
    } catch (e) {
      return RepoResult.error(error: Exception(e.toString()));
    }
  }

  @override
  /// บันทึกการเปิด/ปิด biometric ลง secure storage
  Future<RepoResult<bool>> setBiometricEnabled(bool enabled) async {
    try {
      await requireSecureStorage.setBiometricEnabled(enabled);
      return RepoResult.success(data: true);
    } catch (e) {
      return RepoResult.error(error: Exception(e.toString()));
    }
  }

  @override
  /// อ่านสถานะ biometric จาก secure storage
  Future<RepoResult<bool>> isBiometricEnabled() async {
    try {
      final enabled = await requireSecureStorage.isBiometricEnabled();
      return RepoResult.success(data: enabled);
    } catch (e) {
      return RepoResult.error(error: Exception(e.toString()));
    }
  }

  @override
  /// ล้างสถานะ biometric จาก secure storage
  Future<RepoResult<bool>> clearBiometric() async {
    try {
      await requireSecureStorage.clearBiometric();
      return RepoResult.success(data: true);
    } catch (e) {
      return RepoResult.error(error: Exception(e.toString()));
    }
  }

  @override
  /// ตรวจสอบความพร้อมของ biometric บนอุปกรณ์
  Future<RepoResult<bool>> isBiometricAvailable() async {
    try {
      final isAvailable = await _biometricHelper.isBiometricAvailable();
      return RepoResult.success(data: isAvailable);
    } catch (e) {
      return RepoResult.error(error: Exception(e.toString()));
    }
  }

  @override
  /// ทำ biometric authentication
  /// มีการตรวจเงื่อนไขก่อน:
  /// 1) ต้องเปิด biometric ไว้
  /// 2) ต้องมี PIN ในเครื่อง
  Future<RepoResult<BiometricAuthResult>> authenticateWithBiometric({
    String? reason,
  }) async {
    try {
      final enabledResult = await isBiometricEnabled();
      if (!enabledResult.isSuccess || enabledResult.data != true) {
        return RepoResult.error(error: BiometricNotEnabled());
      }

      final hasPinResult = await hasPin();
      if (!hasPinResult.isSuccess || hasPinResult.data != true) {
        return RepoResult.error(error: BiometricRequiresPin());
      }

      final result = await _biometricHelper.authenticateWithBiometric(
        localizedReason: reason ?? 'กรุณายืนยันตัวตนเพื่อเข้าใช้งาน',
      );

      // ส่งผลลัพธ์ biometric กลับให้ ViewModel ตัดสินใจต่อ
      return RepoResult.success(data: result);
    } catch (e) {
      return RepoResult.error(error: Exception(e.toString()));
    }
  }

  @override
  /// ใช้เช็คว่าอุปกรณ์มี strong biometric หรือไม่
  Future<RepoResult<bool>> hasStrongBiometric() async {
    try {
      final hasStrong = await _biometricHelper.hasStrongBiometric();
      return RepoResult.success(data: hasStrong);
    } catch (e) {
      return RepoResult.error(error: Exception(e.toString()));
    }
  }

  /// รูปแบบ PIN ที่ยอมรับ: ตัวเลข 6 หลัก
  bool _isValidPin(String pin) => RegExp(r'^\d{6}$').hasMatch(pin);
}
