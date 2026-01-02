class DeleteAccountResponse {
  String? status;
  String? message;

  DeleteAccountResponse({
    this.status,
    this.message,
  });

  DeleteAccountResponse.fromJson(Map<String, dynamic> json) {

      status= json["status"];
      message= json["message"];
  }
}
