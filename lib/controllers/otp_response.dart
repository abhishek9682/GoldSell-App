import 'package:flutter/material.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/Send_Otp_Users_Exist.dart';

class OtpProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  bool isLoading = false;
  OtpResponse? otpResponse;

  Future<bool> sendOtp(String phone) async {
    isLoading = true;
    notifyListeners();

    try {
      var body = {"phone": phone};

      var response = await _apiClient.PostMethod(sendsOtp, body);
      print(" otp response is =>>>>>>>>> $response");
      print(" otp body is =>>>>>>>>> $body");
      if (response != null) {
        otpResponse = OtpResponse.fromJson(response);
        isLoading = false;
        notifyListeners();
        return otpResponse?.data?.otpSent == true;
      }
    } catch (e) {
      print("Send OTP Error: $e");
    }

    isLoading = false;
    notifyListeners();
    return false;
  }

  // ✅ VERIFY OTP API
  Future<bool> verifyOtp(String phone, String otp) async {
    isLoading = true;
    notifyListeners();

    try {
      var body = {
        "mobile": phone,
        "otp": otp,
      };

      var response = await _apiClient.PostMethod(sendsOtp, body);

      if (response != null) {
        var verifyResponse = OtpResponse.fromJson(response);

        isLoading = false;
        notifyListeners();

        return verifyResponse.data?.message == "OTP verified successfully";
      }
    } catch (e) {
      print("Verify OTP Error: $e");
    }

    isLoading = false;
    notifyListeners();
    return false;
  }
}
