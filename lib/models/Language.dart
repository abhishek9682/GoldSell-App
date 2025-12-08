class LanguageResponse {
  String? status;
  LanguageList? data;

  LanguageResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"] ?? '';
    data = json["data"] != null ? LanguageList.fromJson(json["data"]) : null;
  }
}

class LanguageList {
  List<LanguageData> languages = [];
  int? defaultLanguageId;

  LanguageList.fromJson(Map<String, dynamic> json) {
    if (json["languages"] != null) {
      languages = List<LanguageData>.from(
        json["languages"].map((e) => LanguageData.fromJson(e)),
      );
    }
    defaultLanguageId = json["default_language_id"];
  }
}

class LanguageData {
  int? id;
  String? name;
  String? shortName;
  String? flag;
  int? rtl;

  LanguageData.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    shortName = json["short_name"];
    flag = json["flag"];
    rtl = json["rtl"];
  }
}
