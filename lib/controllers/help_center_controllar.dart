import 'package:flutter/material.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/help_center.dart';

class HelpCenterProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  HelpCenterResponse? helpCenterResponse;

  ApiClient apiClient = ApiClient();

  Future<bool> fetchHelpCenter() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await apiClient.getMethod(helpCenter);

      helpCenterResponse = HelpCenterResponse.fromJson(response);
      print("help api response =========== $response");
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("Help Center API Error: $e");
      return false;
    }
  }
}
