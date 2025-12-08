class OtpResponse {
  String? status;
  OtpData? data;

  OtpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? OtpData.fromJson(json['data']) : null;
  }
}

class OtpData {
  bool? userExists;
  bool? otpSent;
  String? message;
  int? otp;

  OtpData.fromJson(Map<String, dynamic> json) {
    userExists = json['user_exists'];
    otpSent = json['otp_sent'];
    message = json['message'];
    otp = json['otp'];
  }
}
