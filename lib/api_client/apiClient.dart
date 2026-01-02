import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constants/constant.dart';
import '../utils/token_storage.dart';

class ApiClient{

  Future<Map<String, String>> _headers() async{
    String? token=await TokenStorage.getToken();
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    };
  }

  // 1 get type api
  Future<dynamic> getMethod(String endPoints) async {
    try{
     final Uri url=Uri.parse("$base_url$endPoints");

      final response=await http.get(
          url,
          headers:await _headers()
      );

      return _dynamicResponse(response);

    }catch(error){
      print("Exception ${error}");
      return null;
    }
  }

  // 2 post type api

  Future<dynamic> PostMethod(String endPoints,Map<String,dynamic> body) async {
    try {
      Uri url = Uri.parse("$base_url$endPoints");

      final response = await http.post(
          url,
          headers: await _headers(),
          body: jsonEncode(body)
      );

     return _dynamicResponse(response);

    }catch(error){
      print("Exception $error");
      return null;
    }
  }

  Future<dynamic> PostMethodWithToken(String endPoints,Map<String,dynamic> body, String token) async {
    try {
      Uri url = Uri.parse("$base_url$endPoints");

      final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(body)
      );

      return _dynamicResponse(response);

    }catch(error){
      print("Exception $error");
      return null;
    }
  }

  // 3 put type api
  Future<dynamic> putMethod(String endpoint, Map<String, dynamic> body) async {
    try {
      Uri url = Uri.parse("$base_url$endpoint");

      final response = await http.put(
        url,
        headers: await _headers(),
        body: jsonEncode(body),
      );
      return _dynamicResponse(response);

    } catch (e) {
      print("PUT Error: $e");
      return null;
    }
  }

  // 4 delete type api

  Future<dynamic> deleteBankAccount(String endpoint) async {
    try {

      Uri url = Uri.parse("$base_url$endpoint");
      final response = await http.delete(
        url,
        headers: await _headers(),
      );
     return _dynamicResponse(response);

    } catch (e) {
      print("DELETE Error: $e");
      return null;
    }
  }

  // 5 MultipartFile type api

  Future<dynamic> multiPartMethod(String endpoint, Map<String,String> field  ,Map<String,File> files) async{
      Uri url =Uri.parse("$base_url$endpoint");
      final response=await http.MultipartRequest("POST",url);
      
      response.headers.addAll(await _headers());
      response.fields.addAll(field);

      for (var entry in files.entries) {
        response.files.add(
          await http.MultipartFile.fromPath(
            entry.key,
            entry.value.path,  // ✅ Correct: use .path
          ),
        );
      }

      var streamedResponse = await response.send();
      var responses   = await http.Response.fromStream(streamedResponse);
      debugPrint("response of api ${responses.body}");
      return _dynamicResponse(responses);
  }

  // dynamic response

   dynamic _dynamicResponse(http.Response response){
    if(response.statusCode==200){
      return jsonDecode(response.body);
    }
    else{
      print("Error is ${response.statusCode} - ${response.body}");
    }
    return null;
  }
}

