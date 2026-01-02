import 'package:flutter/cupertino.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/convert_gold_or_money.dart';

class GoldDetails with ChangeNotifier {
  GoldCalculationResponse? get goldCalculationResponse => _goldCalculationResponse;
  GoldCalculationResponse? _goldCalculationResponse;
  ApiClient appClient = ApiClient();
  Map<String,String> body={};

  Future<void> goldDetails(body) async {
    final response = await appClient.PostMethod(convertGoldOrMoney,body);
    print(body);
    print("gold response +====>>>>  $response");

      _goldCalculationResponse = GoldCalculationResponse.fromJson(response);
      notifyListeners();
  }
}
