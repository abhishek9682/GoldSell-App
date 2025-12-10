import 'package:flutter/material.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';

class OtpResendProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  Map<String, dynamic>? otpResponse; // store raw API response

  Future<bool> otpResend(Map<String, dynamic> body) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await ApiClient().PostMethod(sendsOtp, body);

      otpResponse = response;
      print("OTP RESEND RESPONSE =============> $response");

      _loading = false;
      notifyListeners();

      if (response["status"] == "success") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("OTP RESEND ERROR: $e");
      _loading = false;
      notifyListeners();
      return false;
    }
  }
}
