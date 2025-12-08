import 'package:flutter/material.dart';
import 'package:goldproject/api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/investment_transaction.dart';

class InvestmentPlanTransactionsProvider with ChangeNotifier {
  final ApiClient api = ApiClient();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isMoreLoading = false;
  bool get isMoreLoading => _isMoreLoading;

  String? error;

  int currentPage = 1;
  int lastPage = 1;

  List<TransactionItem> allTransactions = [];
  List<TransactionItem> planTransactions = [];

  // FETCH API
  Future<void> fetchTransactionsForPlan({
    required int planId,
    bool refresh = false,
  }) async {
    if (refresh) {
      currentPage = 1;
      allTransactions.clear();
      planTransactions.clear();
    }

    _isLoading = refresh;
    _isMoreLoading = !refresh;
    notifyListeners();

    try {
      final response =
      await api.getMethod("$investmentPlanTransactions?page=$currentPage");

      if (response != null) {
        final model = TransactionsResponse.fromJson(response);

        final List<TransactionItem> fetched =
            model.data?.transactions ?? [];

        allTransactions.addAll(fetched);

        currentPage = model.data?.pagination?.currentPage ?? 1;
        lastPage = model.data?.pagination?.lastPage ?? 1;

        // FILTER BY PLAN
        planTransactions = allTransactions
            .where((t) => t.plan?.id == planId)
            .toList();
      }
    } catch (e) {
      error = e.toString();
    }

    _isLoading = false;
    _isMoreLoading = false;
    notifyListeners();
  }

  Future<void> loadMore(int planId) async {
    if (currentPage >= lastPage) return;

    currentPage++;
    await fetchTransactionsForPlan(planId: planId, refresh: false);
  }
}
