import 'dart:io';

import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/submit_kyc.dart';
import 'package:flutter/material.dart';

class SubmitKycProvider with ChangeNotifier{
  ApiClient apiClient=ApiClient();
  KycSubmitResponse?  submitKyc;
  Map<String,dynamic> fields={};
  bool _isLoading=false;
  bool get isLoading=>_isLoading;
  Map<String,File> file={};

  Future<dynamic> kycDoc(Map<String, String> fields, Map<String, File> file) async {
    try {
      _isLoading = true;
      notifyListeners();
       print("submit bodyv       ------ $fields");
      final response = await apiClient.multiPartMethod(
          submitKycs,
          fields,
          file
      );

      print("submitKyc response : $response");

      submitKyc = KycSubmitResponse.fromJson(response ?? {});
      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("submitKyc error $e");
    }
  }

}