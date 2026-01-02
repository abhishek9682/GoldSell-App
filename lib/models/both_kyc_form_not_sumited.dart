class KycStatusResponse {
  String? status;
  String? message;
  String? data;
  List<String>? pendingForms;
  List<String>? approvedForms;
  List<String>? notSubmittedForms;

  KycStatusResponse({
    this.status,
    this.message,
    this.data,
    this.pendingForms,
    this.approvedForms,
    this.notSubmittedForms,
  });

  KycStatusResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = json["data"];
    pendingForms = json["pending_forms"] != null
        ? List<String>.from(json["pending_forms"])
        : [];
    approvedForms = json["approved_forms"] != null
        ? List<String>.from(json["approved_forms"])
        : [];
    notSubmittedForms = json["not_submitted_forms"] != null
        ? List<String>.from(json["not_submitted_forms"])
        : [];
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data,
      "pending_forms": pendingForms,
      "approved_forms": approvedForms,
      "not_submitted_forms": notSubmittedForms,
    };
  }
}
