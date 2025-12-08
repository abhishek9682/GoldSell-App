  import 'package:flutter/material.dart';
  import '../api_client/apiClient.dart';
  import '../constants/end_points.dart';
  import '../models/varify_otp_new_user.dart';
  import '../utils/token_storage.dart';

  class OtpVarification with ChangeNotifier {
    bool isLoading = false;
    String? apiStatus;
    VerifyOtpResponse? verifyOtpResponse;
    TokenStorage shared=TokenStorage();

    Future<bool> verifyOtp(String phone, String otp) async {
      try {
        isLoading = true;
        apiStatus = null;
        notifyListeners();

        final body = {
          "phone": phone,
          "otp": otp,
        };
      print("body of otp------->> $body");
        final response = await ApiClient().PostMethod(verifyOtps, body);
        print("otp varificatio failded ^^^^^^^^^   $response");
        if (response != null && response["status"] == "success") {
          verifyOtpResponse = VerifyOtpResponse.fromJson(response);
          apiStatus = "success";

          return true;
        } else {
          apiStatus = response?["message"] ?? "OTP verification failed";
          return false;
        }
      } catch (e) {
        apiStatus = "Something went wrong!";
        return false;
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }
