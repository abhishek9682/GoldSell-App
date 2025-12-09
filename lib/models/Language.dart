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
  String? nativeName;
  String? shortName;
  String? langCode;
  String? flag;
  String? fontFamily;
  int? rtl;

  LanguageData.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    nativeName = json["native_name"];
    shortName = json["short_name"];
    langCode = json["lang_code"];
    flag = json["flag"];
    fontFamily = json["font_family"];
    rtl = json["rtl"];
  }
}
