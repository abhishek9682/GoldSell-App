import 'dart:io';

import 'package:flutter/material.dart';
import '../api_client/apiClient.dart';
import '../constants/end_points.dart';
import '../models/update_profile.dart';

class NomineeProfileProvider with ChangeNotifier {
  final ApiClient apiClient = ApiClient();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _message = "";
  String get message => _message;
  ProfileUpdateResponse? _profileResponse;
  ProfileUpdateResponse? get profileResponse => _profileResponse;

  bool editingNominee=false;
  notifyListeners();
  // Update nominee fields only (no image)
  Future<bool> updateNominee(Map<String, String> fields,Map<String,File> files, bool editingNominee) async {
    _isLoading = true;
    editingNominee=true;
    notifyListeners();

    // try {
      final response = await apiClient.multiPartMethod(updateProfiles, fields,files);
      print("nominee response after update-----------   ${response} ");
      print("nominee update ^^^^^ $fields  --- $files");
      if (response != null && response["status"] == "success") {
        if(response["updated_fields"].isNotEmpty) {
          _profileResponse = ProfileUpdateResponse.fromJson(response);
        }
        print("nominee update controllar  ^^^^^ $_profileResponse");
        _isLoading = false;
        editingNominee=false;

        notifyListeners();
        return true;
      }
      else
        {
          _message=response["data"][0];
          notifyListeners();
          _isLoading = false;
          return false;
        }
    // } catch (e) {
    //   debugPrint("Error updating: $e");
    // }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
