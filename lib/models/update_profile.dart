class ProfileUpdateResponse {
  String? status;
  String? message;
  int? totalUpdated;
  UpdatedFields? updatedFields;

  ProfileUpdateResponse({
    this.status,
    this.message,
    this.totalUpdated,
    this.updatedFields,
  });

  ProfileUpdateResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    totalUpdated = json["total_updated"];
    updatedFields = json["updated_fields"] != null
        ? UpdatedFields.fromJson(json["updated_fields"])
        : null;
  }

}

class UpdatedFields {
  // ✅ For Case 1 (Personal)
  String? firstname;
  String? lastname;
  String? email;

  // ✅ For Case 2 (Address)
  String? city;
  String? zipCode;
  String? address;

  // ✅ For Case 3 (Nominee)
  String? nomineeName;
  String? nomineeAge;
  String? nomineeMobileNumber;

  UpdatedFields({
    this.firstname,
    this.lastname,
    this.email,
    this.city,
    this.zipCode,
    this.address,
    this.nomineeName,
    this.nomineeAge,
    this.nomineeMobileNumber,
  });

  UpdatedFields.fromJson(Map<String, dynamic> json) {
    // ✅ Personal
    firstname = json["firstname"];
    lastname = json["lastname"];
    email = json["email"];

    // ✅ Address
    city = json["city"];
    zipCode = json["zip_code"];
    address = json["address"];

    // ✅ Nominee
    nomineeName = json["nominee_name"];
    nomineeAge = json["nominee_age"];
    nomineeMobileNumber = json["nominee_mobile_number"];
  }
}

