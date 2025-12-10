class OtpResendResponse {
  String? status;
  OtpResendData? data;
  String? errorMessage;

  OtpResendResponse({
    this.status,
    this.data,
    this.errorMessage,
  });

  factory OtpResendResponse.fromJson(Map<String, dynamic> json) {
    return OtpResendResponse(
      status: json["status"],
      data: json["data"] is Map<String, dynamic>
          ? OtpResendData.fromJson(json["data"])
          : null,
      errorMessage: json["data"] is String ? json["data"] : null,
    );
  }
}

class OtpResendData {
  String? message;
  String? token;
  bool? profileCompleted;
  UserData? user;

  OtpResendData({
    this.message,
    this.token,
    this.profileCompleted,
    this.user,
  });

  factory OtpResendData.fromJson(Map<String, dynamic> json) {
    return OtpResendData(
      message: json["message"],
      token: json["token"],
      profileCompleted: json["profile_completed"],
      user: json["user"] != null ? UserData.fromJson(json["user"]) : null,
    );
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

  UserData({
    this.id,
    this.customerId,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.username,
    this.dateOfBirth,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json["id"],
      customerId: json["customer_id"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      email: json["email"],
      phone: json["phone"],
      username: json["username"],
      dateOfBirth: json["date_of_birth"],
    );
  }
}
