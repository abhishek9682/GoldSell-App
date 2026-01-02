class UserRegistration {
  String? status;
  ProfileData? data;

  UserRegistration({this.status, this.data});

  UserRegistration.fromJson(Map<String, dynamic> json) {
      status=json["status"];
      data=json["data"] != null ? ProfileData.fromJson(json["data"]) : null;
    
  }
}

class ProfileData {
  String? message;
  User? user;

  ProfileData({this.message, this.user});

   ProfileData.fromJson(Map<String, dynamic> json) {
      message= json["message"];
      user=json["user"] != null ? User.fromJson(json["user"]) : null;
  }
}

class User {
  int? id;
  String? customerId;
  String? firstname;
  String? lastname;
  String? email;
  String? username;
  String? phone;
  String? dateOfBirth;

  User({
    this.id,
    this.customerId,
    this.firstname,
    this.lastname,
    this.email,
    this.username,
    this.phone,
    this.dateOfBirth,
  });

   User.fromJson(Map<String, dynamic> json) {

      id=json["id"];
      customerId= json["customer_id"];
      firstname=json["firstname"];
      lastname=json["lastname"];
      email=json["email"];
      username= json["username"];
      phone=json["phone"];
      dateOfBirth= json["date_of_birth"];
  }
}
