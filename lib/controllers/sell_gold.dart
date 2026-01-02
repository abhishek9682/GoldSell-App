import 'package:flutter/material.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/sell_gold.dart';

class GoldSellProvider with ChangeNotifier {
  GoldSellResponse? _sellResponse;
  bool isLoading = false;
  String? res;
  GoldSellResponse? get sellResponse => _sellResponse;

  final ApiClient apiClient = ApiClient();

  Future<bool> sellGold(Map<String, dynamic> body) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await apiClient.PostMethod(sellGOld, body);
      print("gold sell response ====== $response");
      print("gold sell body ====== $body");

      if (response != null && response["status"] == "success") {
        _sellResponse = GoldSellResponse.fromJson(response);
        return true;   // SUCCESS
      }
      res=response['data'];
      return false;    // FAILED (status != success)

    } catch (e) {
      print("🔥 sellGold ERROR: $e");
      return false;    // ERROR OCCURRED
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
