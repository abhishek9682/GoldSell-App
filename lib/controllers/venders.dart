import 'package:flutter/foundation.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/get_all_merchants_filters.dart';

class MerchantProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  MerchantListResponse? merchantResponse;

  ApiClient apiClient = ApiClient();

  int currentPage = 1;
  bool hasMore = true;

  // Fetch merchants (pagination supported)
  Future<bool> fetchMerchants({int page = 1}) async {
    try {
      _loading = true;
      notifyListeners();

      final response = await apiClient.getMethod(vender);

      merchantResponse = MerchantListResponse.fromJson(response);

      // Pagination logic
      currentPage = merchantResponse?.data?.currentPage ?? 1;
      hasMore = merchantResponse?.data?.nextPageUrl != null;

      print("Merchant API Response ========= $response");

      _loading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _loading = false;
      notifyListeners();
      print("Merchant API Error: $e");
      return false;
    }
  }
}
