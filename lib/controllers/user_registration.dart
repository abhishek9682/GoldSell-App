import 'package:flutter/material.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/user_registration.dart';

class CompleteProfileProvider with ChangeNotifier {
  ApiClient apiClient=ApiClient();
  String _message="";
  String get message=>_message;
  bool isLoading = false;
  String? apiStatus;
  UserRegistration? profileResponse;

  Future<bool> completeProfile(Map<String, dynamic> body, String token) async {
    try {
      isLoading = true;
      apiStatus = null;
      notifyListeners();

      final response = await apiClient.PostMethodWithToken(userRegistration, body,token);
      print("$response");

      if (response != null && response["status"] == "success") {
        profileResponse = UserRegistration.fromJson(response);

        apiStatus = "success";
        return true;
      } else {
        apiStatus = response?["data"][0] ?? "Profile update failed";
        _message=response['data'];
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
