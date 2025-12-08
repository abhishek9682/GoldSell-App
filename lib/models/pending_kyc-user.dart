class KycStatusResponse {
  String? status;
  String? message;
  String? data;
  List<String>? pendingForms;
  List<String>? approvedForms;

  KycStatusResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = json["data"];
    pendingForms = json["pending_forms"] != null
        ? List<String>.from(json["pending_forms"].map((x) => x))
        : [];
    approvedForms = json["approved_forms"] != null
        ? List<String>.from(json["approved_forms"].map((x) => x))
        : [];
  }
}
