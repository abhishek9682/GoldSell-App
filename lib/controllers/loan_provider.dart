import 'package:flutter/material.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/loan_inquiry.dart';

class GoldLoanProvider with ChangeNotifier {
  final ApiClient apiClient = ApiClient();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _message = "";
  String get message => _message;

  GoldLoanResponse? _goldLoanResponse;
  GoldLoanResponse? get goldLoanResponse => _goldLoanResponse;

  Future<bool> submitGoldLoan(Map<String, dynamic> fields) async {
    _isLoading = true;
    notifyListeners();

    final response = await apiClient.PostMethod(loan,fields,);

    print("Gold loan response -------- $response");

    if (response != null && response["status"] == "success") {
      _goldLoanResponse = GoldLoanResponse.fromJson(response);
      _message = response["data"]["message"];

      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _message = response?["message"] ?? "Something went wrong";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
