import 'package:flutter/material.dart';
import 'package:goldproject/api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/term_constion_model.dart';

class TermsConditionsProvider with ChangeNotifier {
  ApiClient apiClient=ApiClient();
  bool _isLoading = false;
  TermsConditionsModel? _termsData;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  TermsConditionsModel? get termsData => _termsData;
  String? get errorMessage => _errorMessage;

  /// Fetch Terms & Conditions from API
  Future<void> fetchTermsConditions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await apiClient.getMethod(termsCondition);

      if (response != null) {
        _termsData = TermsConditionsModel.fromJson(response);
      } else {
        _errorMessage = "No data received";
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
