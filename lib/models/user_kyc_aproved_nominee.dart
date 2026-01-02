class KycPendingResponse {
  String? status;
  String? message;
  String? data;
  List<String>? pendingForms;
  List<String>? approvedForms;

  KycPendingResponse({
    this.status,
    this.message,
    this.data,
    this.pendingForms,
    this.approvedForms,
  });

  KycPendingResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = json["data"];
    pendingForms = json["pending_forms"] != null
        ? List<String>.from(json["pending_forms"])
        : [];
    approvedForms = json["approved_forms"] != null
        ? List<String>.from(json["approved_forms"])
        : [];
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data,
      "pending_forms": pendingForms,
      "approved_forms": approvedForms,
    };
  }
}
