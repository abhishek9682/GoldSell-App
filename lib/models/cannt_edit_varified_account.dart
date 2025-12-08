class BankAccountErrorResponse {
  String? status;
  String? message;

  BankAccountErrorResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
  }
}
