import 'package:flutter/material.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/Language.dart'; // Updated model

class LanguageProvider with ChangeNotifier {
  final ApiClient apiClient = ApiClient();

  bool _loading = false;
  bool get loading => _loading;

  List<LanguageData> _languages = [];
  List<LanguageData> get languages => _languages;

  int? defaultLangId;

  // Current app locale
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  // -------------------------------------------------------------
  // FETCH LANGUAGE LIST FROM API
  // -------------------------------------------------------------
  Future<void> fetchLanguages() async {
    _loading = true;
    notifyListeners();

    try {
      final response = await apiClient.getMethod(language);

      if (response != null) {
        LanguageResponse langResponse = LanguageResponse.fromJson(response);

        _languages = langResponse.data?.languages ?? [];
        defaultLangId = langResponse.data?.defaultLanguageId;

        // 🔥 AUTO-SET DEFAULT LANGUAGE
        if (defaultLangId != null) {
          LanguageData? defaultLang = _languages.firstWhere(
                (e) => e.id == defaultLangId,
            orElse: () => _languages.first,
          );

          if (defaultLang.shortName != null) {
            _locale = Locale(defaultLang.shortName!);
          }
        }
      } else {
        _languages = [];
        defaultLangId = null;
      }
    } catch (e) {
      debugPrint("🔥 Error fetching languages: $e");
      _languages = [];
    }

    _loading = false;
    notifyListeners();
  }

  // -------------------------------------------------------------
  // CHANGE LANGUAGE (Manual User Selection)
  // -------------------------------------------------------------
  void changeLanguage(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }
}
