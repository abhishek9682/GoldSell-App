import 'package:flutter/material.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/enroll_investment_plans.dart';

class EnrollInvestmentProvider with ChangeNotifier {

  final ApiClient apiClient = ApiClient();


  bool _loading = false;
  bool get loading => _loading;
  bool _success = false;
  bool get success => true;
  String? _message;
  String? get message => _message;

  Future<void> enrollInvestment(Map<String, dynamic> fields) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await apiClient.PostMethod(enrollInvestments, fields);

      print("📩 Enroll Investment Response: $response");
      print("📤 Fields Sent: $fields");

      if (response != null) {
        if(response["status"]=="success")
          {
            _success=true;
            _message=response["data"]["message"];
          }
        else
          {
            _success=false;
            _message=response["data"][0];
          }
      } else {
      }
    } catch (e) {
      debugPrint("❌ ERROR: $e");
    }
    finally
        {
          _loading = false;
          notifyListeners();
        }
  }
}
