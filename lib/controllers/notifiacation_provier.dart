import 'package:flutter/material.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/notyfication.dart';

class NotificationProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NotificationResponse? notificationResponse;

  final ApiClient _apiClient = ApiClient();

  Future<bool> fetchNotifications() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.getMethod(notifiacation);
      notificationResponse = NotificationResponse.fromJson(response);

      print("NOTIFICATION API RESPONSE ==== $response");

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("Notification API Error: $e");
      return false;
    }
  }
}
