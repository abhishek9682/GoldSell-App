class KycPendingResponse {
  String? status;
  String? message;
  String? data;
  List<String>? pendingForms;

  KycPendingResponse();

  KycPendingResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = json["data"];
    pendingForms = json["pending_forms"] != null
        ? List<String>.from(json["pending_forms"].map((x) => x.toString()))
        : [];
  }
}
