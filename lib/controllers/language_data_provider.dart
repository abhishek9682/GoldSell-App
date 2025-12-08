import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goldproject/api_client/apiClient.dart';
import 'package:goldproject/constants/end_points.dart';

import '../utils/token_storage.dart';

class LanguageDataProvider with ChangeNotifier {
  ApiClient appClient = ApiClient();
  String get langIs =>_langIs;
  String _langIs="";
  bool _isSelected = false;
  bool get isSelected => _isSelected;
  Map<String, dynamic> langData = {};

  Future<void> getLanguageData(String id) async {

    try {
      final response = await appClient.getMethod('$languageData$id');


      if (response != null) {
        String jsonData=jsonEncode(response); // json because share_prefered use json
        TokenStorage.saveLang(jsonData);
        TokenStorage.saveLan(id);
        TokenStorage.init();
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Language API Error: $e");
    }
  }


  void setSelected(bool value) {
    _isSelected = value;
    notifyListeners();
  }
}
