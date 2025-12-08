import 'package:flutter/material.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/Language.dart'; // LanguageResponse, Language_List, Language_Data

class LanguageProvider with ChangeNotifier {
  final ApiClient apiClient = ApiClient();
  int? defaultLangId;
  List<LanguageData> _languages = [];
  bool _loading = false;

  Locale _locale = const Locale('en');   // <-- ADD THIS
  Locale get locale => _locale;          // <-- ADD THIS

  List<LanguageData> get languages => _languages;
  bool get loading => _loading;

  Future<void> fetchLanguages() async {
    _loading = true;
    notifyListeners();

    try {
      final response = await apiClient.getMethod(language); // endpoint
      if (response != null) {
        LanguageResponse langResponse = LanguageResponse.fromJson(response);
        _languages = langResponse.data?.languages ?? [];
        defaultLangId= langResponse.data?.defaultLanguageId;
      } else {
        _languages = [];
        defaultLangId=null;
      }
    } catch (e) {
      debugPrint("Error fetching languages: $e");
      _languages = [];
    }

    _loading = false;
    notifyListeners();
  }

  // ⭐ ADD THIS FUNCTION TO CHANGE APP LANGUAGE
  void changeLanguage(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }
}
