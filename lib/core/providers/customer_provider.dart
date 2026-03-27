// import 'package:browny_applications_new/core/data/remote/models/response/customer_profile_response.dart';
// import 'package:browny_applications_new/feature/transactions/models/machine_program_model.dart';
// import 'package:browny_applications_new/models/user_model.dart';
// import 'package:flutter/material.dart';

// class CustomerProvider extends ChangeNotifier {
//   UserModel _current = UserModel.guest();
//   UserModel get current => _current;

//   /// ใช้สำหรับเก็บ Transactions ของ User เอาไว้ เช่น การสั่งเครื่องซัก/อบ
//   /// อนาคตรองรับ BownyShop
//   UserTransactionsHolder _transactionsHolder = UserTransactionsHolder(
//     machineUsing: {},
//   );

//   /// getter ไว้สำหรับตรวจสอบ Transactions ที่ User มี
//   UserTransactionsHolder get userTransactions => _transactionsHolder;

//   /// setter สำหรับ Update Transaction ใหม่ หรือ ของเดิมที่มีอยู่
//   set updateTransactions(UserTransactionsHolder newTransaction) {
//     _transactionsHolder = newTransaction;
//   }

//   /// เช็ค Transaction ทั้งหมดของ User ที่มี
//   bool get hasTransaction => userTransactions.machineUsing.isNotEmpty;

//   /// เช็ค Transaction การใช้งานเครื่องซัก/อบ ที่มี
//   bool get hasMachineUsing => userTransactions.machineUsing.isNotEmpty;

//   set newUser(UserModel data) {
//     _current = data;
//     notifyListeners();
//   }

//   void updateCreditAndCoinBalance(CustomerProfileData data) {
//     newUser = current.copyWith(
//       creditBalance: data.creditBalance,
//       brownyCoin: data.brownyCoin,
//     );
//   }

//   UserModel logout() {
//     _current = UserModel.guest();
//     notifyListeners();
//     return _current;
//   }
// }

// class UserTransactionsHolder {
//   UserTransactionsHolder({
//     required this.machineUsing,
//   });

//   final Map<String, MachineProgramModel> machineUsing;

//   void addNewMachineTracsactions(MachineProgramModel machine) {
//     machineUsing.putIfAbsent(machine.machineId.toString(), () => machine);
//   }

//   UserTransactionsHolder copyWith({
//     UserTransactionsHolder? newInstance,
//   }) {
//     return UserTransactionsHolder(
//       machineUsing: newInstance?.machineUsing ?? machineUsing,
//     );
//   }
// }

/// Minimal auth state for BrownyPlus.
///
/// NOTE: นี่เป็นตัวแปรสำหรับแชร์ข้อมูลระหว่างหน้า auth (login -> otp -> pin -> reset)
/// เพื่อทดสอบการทำงาน ก่อนจะย้ายไปยัง state management ที่สมบูรณ์ขึ้น
class AuthSession {
  /// Customer id ที่ได้จาก `login` หรือ `verify-otp`
  static String? customerId;

  /// username (email/phone) ที่ใช้ขอ OTP
  static String? otpUsername;

  /// ref_code ที่ได้จาก `request-otp`
  static String? otpRefCode;

  static void clear() {
    customerId = null;
    otpUsername = null;
    otpRefCode = null;
  }

  static bool get hasCustomerId => (customerId ?? '').isNotEmpty;
}
