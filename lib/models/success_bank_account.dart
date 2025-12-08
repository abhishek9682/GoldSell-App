class BankAccountDeleteResponse {
  String? status;
  String? data;

  BankAccountDeleteResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    data = json["data"];
  }
}
