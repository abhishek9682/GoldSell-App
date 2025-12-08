import 'package:flutter/material.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/add_bank_account.dart';

class BankAccountProvider with ChangeNotifier {
  final ApiClient apiClient = ApiClient();
  BankAccountResponse? get addbankAcc =>_addbankAcc;
  BankAccountResponse? _addbankAcc;
  String _message="";
  String get message=>_message;
  bool _loading = false;
  bool get loading => _loading;

  Future<bool> addBankAccount({
    required String bankName,
    required String accountHolder,
    required String accountNumber,
    required String confirmAccountNumber,
    required String ifsc,
    required String branch,
    required String accountType,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      Map<String, dynamic> body = {
        "bank_name": bankName,
        "account_holder_name": accountHolder,
        "account_number": accountNumber,
        "confirm_account_number": confirmAccountNumber,   // ✅ FIXED
        "ifsc_code": ifsc,
        "branch_name": branch,
        "account_type": accountType,   // savings / current
      };

      final response = await apiClient.PostMethod(addBankAccounts, body);
      _addbankAcc=BankAccountResponse.fromJson(response);
      print("📌 Add Bank API Response: $response");
      print("📌 Add Bank API Response: $body");

      if (response != null && response["status"] == "success") {
        _loading = false;
        notifyListeners();
        return true;
      } else {
        // BankAccountResponse error = BankAccountResponse.fromJson(response ?? {});
        // debugPrint("❌ Bank Account Error: ${error.message}");
        _message=response["data"][0];
        _loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint("❌ Exception adding bank account: $e");
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBankAccountDetail({
    required String bankName,
    required String accountHolder,
    required String accountNumber,
    required String confirmAccountNumber,
    required String ifsc,
    required String branch,
    required String accountType,
    required String bankId
  }) async {
    _loading = true;
    notifyListeners();

    try {
      Map<String, dynamic> body = {
        "bank_name": bankName,
        "account_holder_name": accountHolder,
        "account_number": accountNumber,
        "confirm_account_number": confirmAccountNumber,   // ✅ FIXED
        "ifsc_code": ifsc,
        "branch_name": branch,
        "account_type": accountType,   // savings / current
      };

      final response = await apiClient.putMethod("${updateBankAccount}/$bankId", body);
      _addbankAcc=BankAccountResponse.fromJson(response);
      print("📌 Add Bank API Response: $response");
      print("📌 Add Bank API Response: $body");

      if (response != null && response["status"] == "success") {
        _loading = false;
        notifyListeners();
        return true;
      } else {
        // BankAccountResponse error = BankAccountResponse.fromJson(response ?? {});
        // debugPrint("❌ Bank Account Error: ${error.message}");
        _message=response["data"][0];
        _loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint("❌ Exception adding bank account: $e");
      _loading = false;
      notifyListeners();
      return false;
    }
  }

}
