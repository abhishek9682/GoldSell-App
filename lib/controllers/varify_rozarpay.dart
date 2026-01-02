import 'package:flutter/material.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';

class RazorpayVerifyProvider with ChangeNotifier {
  final ApiClient apiClient = ApiClient();

  bool _loading = false;
  bool get loading => _loading;

  String? _message;
  String? get message => _message;

  bool _success = false;
  bool get success => _success;

  /// 🔥 Verify Razorpay payment after success
  Future<bool> verifyPayment(Map<String, dynamic> verifyBody) async {
    _loading = true;
    notifyListeners();

    print("🔵 Sending Razorpay Verify Payload: $verifyBody");

    try {
      final response =
      await apiClient.PostMethod(varifyRozaPay, verifyBody);

      print("🟢 Razorpay Verify Response: $response");

      if (response != null && response["status"] == "success") {
        _success = true;
        _message = response["message"]?.toString() ?? "Payment Verified";
        _loading = false;
        notifyListeners();
        return true;
      } else {
        _success = false;

        if (response != null &&
            response["data"] != null &&
            response["data"] is List &&
            response["data"].isNotEmpty) {
          _message = response["data"][0].toString();
        } else {
          _message = "Payment verification failed";
        }

        _loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("❌ Razorpay Verification Error: $e");
      _message = "Something went wrong";
      _success = false;
      _loading = false;
      notifyListeners();
      return false;
    }
  }
}
