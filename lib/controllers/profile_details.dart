import 'package:flutter/material.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/get_profile_details.dart';

class ProfileDetailsProvider with ChangeNotifier {
  final ApiClient apiClient = ApiClient();

  bool _loading = false;
  bool get loading => _loading;

  ProfileResponse? _profileData;
  ProfileResponse? get profileData => _profileData;

  List<BankAccount> get bankAccounts =>
      _profileData?.data?.profile?.bankAccounts ?? [];

  BankAccount? get primaryBank =>
      _profileData?.data?.profile?.primaryBankAccount;
  String? selectedLanguage; // store selected language

  void setSelectedLanguage(String lang) {
    selectedLanguage = lang;
    notifyListeners();
  }
  // -----------------------------
  // FETCH PROFILE DETAILS (BANKS INCLUDED)
  // -----------------------------
  Future<dynamic> fetchProfile() async {
    _loading = true;
    notifyListeners();

    try {
      final response = await apiClient.getMethod(getProfileDetails);
      print("📌 PROFILE details API RESPONSE: $response");

      if (response != null && response["status"] == "success") {
        _profileData = ProfileResponse.fromJson(response);
        _loading = false;
        notifyListeners();
        return true;
      } else {
        _loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint("❌ Error loading profile: $e");
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // -----------------------------
  // SET PRIMARY ACCOUNT
  // -----------------------------
  Future<bool> setPrimaryBank(int bankId) async {
    try {
      final response = await apiClient.PostMethod(
        "${setPrimarty}/$bankId/set-primary",
        {}
      );

      print("📌 PRIMARY UPDATE RESPONSE: $response");

      if (response["status"] == "success") {
        await fetchProfile();  // refresh data
        return true;
      }
      return false;
    } catch (e) {
      print("❌ PRIMARY BANK ERROR: $e");
      return false;
    }
  }

  // -----------------------------
  // REMOVE BANK ACCOUNT
  // -----------------------------
  Future<bool> removeBank(int bankId) async {
    try {
      final response = await apiClient.PostMethod(
        deleteBankAccount,
        {"bank_id": bankId},
      );

      print("📌 REMOVE BANK RESPONSE: $response");

      if (response["status"] == "success") {
        await fetchProfile();
        return true;
      }
      return false;
    } catch (e) {
      print("❌ REMOVE BANK ERROR: $e");
      return false;
    }
  }
}
