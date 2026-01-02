class VerifyOtpResponse {
  String? status;
  VerifyOtpData? data;

  VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? VerifyOtpData.fromJson(json['data']) : null;
  }
}

class VerifyOtpData {
  String? message;
  String? token;
  bool? profileCompleted;
  UserData? user;

  VerifyOtpData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
    profileCompleted = json['profile_completed'];
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
  }
}

class UserData {
  int? id;
  String? customerId;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? username;
  String? dateOfBirth;

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'];
    username = json['username'];
    dateOfBirth = json['date_of_birth'];
  }
}
