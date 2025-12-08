class BankAccountPrimaryErrorResponse {
  String? status;
  String? message;

  BankAccountPrimaryErrorResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
  }
}
