import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/update_profile.dart';

class UpdateProfiles with ChangeNotifier {
  final ApiClient apiClient = ApiClient();

  ProfileUpdateResponse? updateResponse;
  bool _loading = false;
  bool get loading => _loading;

  String message ="null";
  Future<void> updateProfile(Map<String, String> fields, Map<String, File> files) async {
    _loading = true;
    notifyListeners();

    // try {
      final response = await apiClient.multiPartMethod(updateProfiles, fields, files,);
      print("update details response ====..... $response");
      print("📤 Fields: $fields");
      print("📤 Files: $files");
      if (response != null) {
        // final jsonData=response;
        updateResponse = ProfileUpdateResponse.fromJson(response);

        debugPrint("✅ Profile Updated Successfully: ${updateResponse?.status}");
      } else {
        message=response[0]['data'];
        updateResponse = response;
        debugPrint("⚠️ updateProfile(): Response was NULL");
      }
    // } catch (e) {
    //   debugPrint("❌ Error updating profile: $e");
    //   updateResponse = null;
    // }

    _loading = false;
    notifyListeners();
  }
}
