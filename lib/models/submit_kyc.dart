class KycSubmitResponse {
  String? status;
  String? data;

  KycSubmitResponse({this.status, this.data});

  KycSubmitResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    data = json["data"];
  }
}
