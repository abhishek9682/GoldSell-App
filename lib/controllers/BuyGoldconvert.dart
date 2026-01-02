import 'package:flutter/cupertino.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/Guy_Gold_convert.dart';
import '../models/convert_gold_or_money.dart';

class BuyGoldConversion with ChangeNotifier {
  BuyGoldResp? get goldCalculationResponse => _goldCalculationResponse;
  BuyGoldResp? _goldCalculationResponse;
  ApiClient appClient = ApiClient();
  Map<String,String> body={};

  Future<void> buyGoldConvert(body) async {
    final response = await appClient.PostMethod(convertAmountToGold,body);
    print(body);
    print("gold response +====>>>>  $response");

    _goldCalculationResponse = BuyGoldResp.fromJson(response);
    notifyListeners();
  }
}
