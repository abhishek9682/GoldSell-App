import 'package:flutter/cupertino.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/gold_purchage.dart';

class BuyGold with ChangeNotifier {
  GoldPurchaseResponse? _paymentInitiationRequest;
  String? mess = "";

  GoldPurchaseResponse? get paymentInitiationRequest =>
      _paymentInitiationRequest;

  final ApiClient apiClient = ApiClient();

  bool _loading = false;
  bool get loading => _loading;

  Future<bool> buyGold(Map<String, dynamic> body) async {
    _loading = true;
    notifyListeners();

    final response = await apiClient.PostMethod(buyGolds, body);

    print("Buy Gold response:------- $response");

    if (response != null && response["status"] == "success") {
      // ⭐ Parse Razorpay details + trx_id + all gold data
      _paymentInitiationRequest = GoldPurchaseResponse.fromJson(response);

      _loading = false;
      notifyListeners();
      return true;
    } else {
      _loading = false;

      // ⭐ Safely extract error message
      if (response != null &&
          response["data"] != null &&
          response["data"] is List &&
          response["data"].isNotEmpty) {
        mess = response["data"][0].toString();
      } else {
        mess = "Something went wrong";
      }

      notifyListeners();
      return false;
    }
  }



  // Step 2: Verify Payment with Razorpay
  Future<bool> verifyRazorpayPayment(Map<String, dynamic> body) async {
    _loading = true;
    notifyListeners();

    final response = await apiClient.PostMethod(varifyRozaPay, body);
    print("varifiaction response----------$response");
    _loading = false;
    notifyListeners();

    if (response != null && response["status"] == "success") {
      return true;
    } else {
      mess = response["message"] ?? "Verification failed";
      return false;
    }
  }

  // Step 3: Notify Backend Payment Success
  // Future<GoldPurchaseData?> paymentSuccess(String trxId) async {
  //   _loading = true;
  //   notifyListeners();
  //
  //   final response = await apiClient.PostMethod(paymentSuccees, {"trx_id": trxId});
  //   print("succeess response=======  ${response}");
  //   _loading = false;
  //   notifyListeners();
  //
  //   if (response != null && response["status"] == "success") {
  //     return GoldPurchaseData.fromJson(response["data"]);
  //   } else {
  //     mess = response["data"] ?? "Payment success failed";
  //     return null;
  //   }
  // }
  //
  // // Step 4: Notify Backend Payment Failure
  // Future<bool> paymentFailure(String trxId, String reason) async {
  //   _loading = true;
  //   notifyListeners();
  //
  //   final response = await apiClient.PostMethod(paymentFailed, {
  //     "trx_id": trxId,
  //     "reason": reason,
  //   });
  //
  //   _loading = false;
  //   notifyListeners();
  //
  //   return response != null && response["status"] == "success";
  // }
}
