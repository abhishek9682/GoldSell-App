class BankAccountResponse {
  String? status;
  String? message;

  BankAccountResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
  }

  BankAccountResponse.name(this.status, this.message);
}
