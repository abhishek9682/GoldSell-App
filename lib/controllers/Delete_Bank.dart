import 'package:flutter/cupertino.dart';

import '../api_client/apiClient.dart';
import '../constants/end_points.dart';

class DeleteAccount with ChangeNotifier {
  ApiClient apiClient = ApiClient();

  Future<bool> deleteById(int accountId) async {
    try {
      final response = await apiClient.deleteBankAccount(
        "$deleteBankAccount$accountId",
      );

      print("delete bank account response --- $response");

      return response["status"] == "success";
    } catch (e) {
      print("Delete error: $e");
      return false;
    }
  }
}
