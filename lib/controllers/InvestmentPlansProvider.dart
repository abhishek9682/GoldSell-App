import 'package:flutter/material.dart';
import 'package:goldproject/api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/investment_plans.dart';

class InvestmentPlansProvider with ChangeNotifier {
  final ApiClient api = ApiClient();

  bool get isLoading =>_isLoading;
  bool _isLoading=false;
  String? error;

  InvestmentPlansResponse? investmentPlans;  // <-- store full model

  updateLoading(bool isload)
  {
    _isLoading=isload;
    notifyListeners();
  }

  Future<void> getInvestmentPlans() async {
    _isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await api.getMethod(investmentPlan);

      if (response != null) {
        /// convert JSON → Model
        investmentPlans = InvestmentPlansResponse.fromJson(response);
        print("plans  -------  ${investmentPlans?.data.plans }");

      } else {
        error = "Unable to fetch investment plans.";
      }
    } catch (e) {
      error = "Error: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Plan> get plans => investmentPlans?.data.plans ?? [];
  int get totalPlans => investmentPlans?.data.totalPlans ?? 0;
}
