import 'package:flutter/material.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/terms_and_condition.dart';

class PrivacyPolicyProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PrivacyPolicyResponse? privacyPolicyResponse;

  ApiClient apiClient = ApiClient();

  Future<bool> fetchPrivacyPolicy() async {
    try {
      _isLoading = true;
      notifyListeners();

      /// API Call
      final response = await apiClient.getMethod(policy);

      print("Privacy Policy API Response ===== $response");

      /// Parse model
      privacyPolicyResponse = PrivacyPolicyResponse.fromJson(response);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("Privacy Policy API Error: $e");
      return false;
    }
  }
}
