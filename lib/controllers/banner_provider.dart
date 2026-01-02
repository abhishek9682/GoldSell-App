import 'package:flutter/material.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/Banner.dart';

class BannerProvider with ChangeNotifier {
  final ApiClient apiClient = ApiClient();

  bool _loading = false;
  bool get loading => _loading;

  BannerResponse? _bannerResponse;
  BannerResponse? get bannerResponse => _bannerResponse;

  Future<void> fetchBanners() async {
    _loading = true;
    notifyListeners();

    try {
      final response = await apiClient.getMethod(banner);

      _bannerResponse = BannerResponse.fromJson(response);

    } catch (e) {
      print("Banner Fetch Error: $e");
    }

    _loading = false;
    notifyListeners();
  }
}
