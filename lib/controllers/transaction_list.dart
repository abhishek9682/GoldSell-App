import 'package:flutter/material.dart';
import '../api_client/apiClient.dart';
import '../constants/constant.dart';
import '../constants/end_points.dart';
import '../models/Transaction_list.dart';

class TransactionProvider with ChangeNotifier {
  bool isLoading = false;
  TransactionPageData? pageData;
  List<TransactionItem> transactions = [];
  bool isFetchingMore = false;
  bool hasMore = true;
  int currentPage = 1;
  int lastPage = 1;
  ApiClient transactionApi=ApiClient();

  Future<void> fetchTransactions({int page = 1}) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await transactionApi.getMethod(transactionsList);
      TransactionResponse transactionResponse = TransactionResponse.fromJson(response);
      print("transactionResponse ------ ${transactionResponse.data?.transactions}");

      if (transactionResponse.data != null) {
        pageData = transactionResponse.data!;
        transactions = pageData!.transactions ?? [];
      }
    } catch (e) {
      print("Transaction fetch error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (isFetchingMore || !hasMore) return;

    isFetchingMore = true;
    notifyListeners();

    try {
      final nextPage = currentPage + 1;

      final response =
      await transactionApi.getMethod("$transactionsList?page=$nextPage");

      final parsed = TransactionResponse.fromJson(response);

      currentPage = parsed.data?.meta?.currentPage ?? currentPage;
      lastPage = parsed.data?.meta?.lastPage ?? lastPage;

      final newItems = parsed.data?.transactions ?? [];

      transactions.addAll(newItems);

      hasMore = currentPage < lastPage;
    } catch (e) {
      print("❌ Pagination error: $e");
    }

    isFetchingMore = false;
    notifyListeners();
  }

  // -------------------------
  // Filter Logic
  // -------------------------
  List<TransactionItem> filterTransactions(String type) {
    final filterType = type.toLowerCase();

    return transactions.where((txn) {
      final txnType = (txn.transactionType ?? '').toLowerCase();

      if (filterType == 'buy') {
        return txnType == "purchase";
      } else if (filterType == 'sell') {
        return txnType == "sell";
      } else if (filterType == 'rewards') {
        return txnType == "reward";
      }

      return true;
    }).toList();
  }

  List<TransactionItem> get rewardTransactions {
    return transactions.where((txn) {
      final type = txn.transactionType?.toLowerCase() ?? "";
      return type == "reward";
    }).toList();
  }

  // // ------------------------ FILTER TRANSACTIONS ------------------------
  // List<TransactionItem> filterTransactions(String type) {
  //   if (type.toLowerCase() == 'all') return transactions;
  //   return transactions.where((txn) => txn.trxType?.toLowerCase() == type.toLowerCase()).toList();
  // }
}
