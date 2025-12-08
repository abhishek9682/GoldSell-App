import 'package:flutter/cupertino.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/buy_gold.dart';
import '../models/gold_purchage.dart';

class BuyGold with ChangeNotifier {
  GoldPurchaseResponse? _paymentInitiationRequest;
  String? mess="";

  GoldPurchaseResponse? get paymentInitiationRequest =>
      _paymentInitiationRequest;

  final ApiClient apiClient = ApiClient();

  bool _loading = false;
  bool get loading => _loading;

  Future<bool> buyGold(Map<String, dynamic> body) async {
    // try {
      _loading = true;
      notifyListeners();

      final response = await apiClient.PostMethod(buyGolds, body);

      print("Buy Gold response:------- $response");
      print("Buy Gold response keys: ${response.keys}");
      print("Buy Gold response status value: ${response["status"]}");

      if (response != null && response["status"]== "success") {
        _paymentInitiationRequest = GoldPurchaseResponse.fromJson(response);
        _loading = false;
        notifyListeners();
        return true;   // SUCCESS ✔
      } else {
        _loading = false;
        mess=response["data"][0];
        notifyListeners();
        return false;  // FAILURE ❌
      }
    // } catch (e) {
    //   print("Buy Gold API Error: $e");
    //   return false;
    // } finally {
    //   _loading = false;
    //   notifyListeners();
    // }
  }
}
