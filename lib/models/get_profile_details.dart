class ProfileResponse {
  String? status;
  ProfileData? data;

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    data = json["data"] != null ? ProfileData.fromJson(json["data"]) : null;
  }
}

class ProfileData {
  List<Language>? languages;
  Profile? profile;

  ProfileData.fromJson(Map<String, dynamic> json) {
    languages = json["languages"] != null
        ? List<Language>.from(
        json["languages"].map((x) => Language.fromJson(x)))
        : [];

    profile =
    json["profile"] != null ? Profile.fromJson(json["profile"]) : null;
  }
}

class Language {
  int? id;
  String? name;
  String? shortName;
  String? flag;
  String? fontFamily;
  int? rtl;

  Language.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    shortName = json["short_name"];
    flag = json["flag"];
    fontFamily = json["font_family"];
    rtl = json["rtl"];
  }
}

class Profile {
  int? id;
  String? customerId;
  String? firstname;
  String? lastname;
  String? username;
  String? email;
  int? languageId;
  String? phone;
  String? phoneCode;
  String? country;
  String? countryCode;
  String? address;
  String? state;
  String? city;
  String? zipCode;
  String? image;

  String? currentGoldPricePerGram;
  String? goldBalance;
  String? goldBalanceValue;
  String? goldProfit;
  String? totalGoldProfit;
  String? goldInvestAmount;

  String? kycStatus;
  String? kycStatusMessage;
  int? documentsUploaded;

  List<KycGroup>? kycDocuments;
  List<KycGroup>? pendingKycForms;

  List<BankAccount>? bankAccounts;
  bool? hasBankAccount;
  BankAccount? primaryBankAccount;
  String? total_returns;
  String? referralCode;
  ReferralStats? referralStats;

  String? fatherMotherWifeName;
  String? dateOfBirth;
  String? gender;
  String? aadharNumber;
  String? panNumber;
  String? maritalStatus;
  int? dependents;
  String? upiId;
  String? nationality;
  String? occupationType;
  String? organizationName;
  String? designation;
  String? netWorth;

  AnnualIncome? annualIncome;
  Nominee? nominee;

  String? baseCurrency;
  String? currencySymbol;
  String? createdAt;
  String? companyEmail;
  String? companyMobile;

  Profile.fromJson(Map<String, dynamic> json) {
    kycStatus = json["kyc_status"];
    kycStatusMessage = json["kyc_status_message"];

    id = json["id"];
    customerId = json["customer_id"];
    firstname = json["firstname"];
    lastname = json["lastname"];
    username = json["username"];
    email = json["email"];
    languageId = json["language_id"];
    phone = json["phone"];
    phoneCode = json["phone_code"];
    country = json["country"];
    countryCode = json["country_code"];
    address = json["address"];
    state = json["state"];
    city = json["city"];
    zipCode = json["zip_code"];
    image = json["image"];
    total_returns=json[ "total_returns_amount"];
    currentGoldPricePerGram = json["current_gold_price_per_gram"];
    goldBalance = json["gold_balance"];
    goldBalanceValue = json["gold_balance_value"];
    goldProfit = json["gold_profit"];
    totalGoldProfit = json["total_gold_profit"];
    goldInvestAmount = json["gold_invest_amount"];

    documentsUploaded = json["documents_uploaded"];

    kycDocuments = json["kyc_documents"] != null
        ? List<KycGroup>.from(
        json["kyc_documents"].map((x) => KycGroup.fromJson(x)))
        : [];

    pendingKycForms = json["pending_kyc_forms"] != null
        ? List<KycGroup>.from(
        json["pending_kyc_forms"].map((x) => KycGroup.fromJson(x)))
        : [];

    bankAccounts = json["bank_accounts"] != null
        ? List<BankAccount>.from(
        json["bank_accounts"].map((x) => BankAccount.fromJson(x)))
        : [];

    hasBankAccount = json["has_bank_account"];
    primaryBankAccount = json["primary_bank_account"] != null
        ? BankAccount.fromJson(json["primary_bank_account"])
        : null;

    referralCode = json["referral_code"];
    referralStats = json["referral_stats"] != null
        ? ReferralStats.fromJson(json["referral_stats"])
        : null;

    fatherMotherWifeName = json["father_mother_wife_name"];
    dateOfBirth = json["date_of_birth"];
    gender = json["gender"];
    aadharNumber = json["aadhar_number"];
    panNumber = json["pan_number"];
    maritalStatus = json["marital_status"];
    dependents = json["dependents"];
    upiId = json["upi_id"];
    nationality = json["nationality"];
    occupationType = json["occupation_type"];
    organizationName = json["organization_name"];
    designation = json["designation"];
    netWorth = json["net_worth"];

    annualIncome = json["annual_income"] != null
        ? AnnualIncome.fromJson(json["annual_income"])
        : null;

    nominee =
    json["nominee"] != null ? Nominee.fromJson(json["nominee"]) : null;

    baseCurrency = json["base_currency"];
    currencySymbol = json["currency_symbol"];
    createdAt = json["created_at"];
    companyEmail=json["company_info"]["support_email"]??'';
    companyMobile=json["company_info"]["phone"]??'';
  }
}

class KycGroup {
  int? kycId;
  String? kycName;
  String? status;
  int? statusCode;
  int? documentsCount;
  String? submittedAt;

  List<KycFile>? documents;
  List<KycFile>? requiredDocuments;

  KycGroup.fromJson(Map<String, dynamic> json) {
    kycId = json["kyc_id"];
    kycName = json["kyc_name"];
    status = json["status"];
    statusCode = json["status_code"];
    documentsCount = json["documents_count"];
    submittedAt = json["submitted_at"];

    documents = json["documents"] != null
        ? List<KycFile>.from(
        json["documents"].map((x) => KycFile.fromJson(x)))
        : [];

    requiredDocuments = json["required_documents"] != null
        ? List<KycFile>.from(
        json["required_documents"].map((x) => KycFile.fromJson(x)))
        : [];
  }
}

class KycFile {
  String? fieldName;
  String? fieldLabel;
  String? fileUrl;

  KycFile.fromJson(Map<String, dynamic> json) {
    fieldName = json["field_name"];
    fieldLabel = json["field_label"];
    fileUrl = json["file_url"];
  }
}

class BankAccount {
  int? id;
  String? bankName;
  String? accountNumber;
  String? accountHolderName;
  String? ifscCode;
  String? accountType;
  String? branchName;
  bool? isPrimary;
  bool? isVerified;

  BankAccount.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    bankName = json["bank_name"];
    accountHolderName = json["account_holder_name"];
    accountNumber = json["account_number"];
    ifscCode = json["ifsc_code"];
    accountType = json["account_type"];
    branchName = json["branch_name"];
    isPrimary = json["is_primary"];
    isVerified = json["is_verified"];
  }
}

class ReferralStats {
  int? totalReferrals;
  String? totalBonusEarned;

  ReferralStats.fromJson(Map<String, dynamic> json) {
    totalReferrals = json["total_referrals"];
    totalBonusEarned = json["total_bonus_earned"];
  }
}

class AnnualIncome {
  String? salary;
  String? business;
  String? agriculture;
  String? investment;
  String? pension;
  String? others;
  dynamic total;

  AnnualIncome.fromJson(Map<String, dynamic> json) {
    salary = json["salary"];
    business = json["business"];
    agriculture = json["agriculture"];
    investment = json["investment"];
    pension = json["pension"];
    others = json["others"];
    total = json["total"];
  }
}

class Nominee {
  String? name;
  String? relationship;
  int? age;
  String? fatherHusbandName;
  String? contactNumber;
  String? mobileNumber;
  String? aadharNumber;
  String? profilePicture;

  List<KycGroup>? documents;
  List<KycGroup>? pendingKycForms;

  Nominee.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    relationship = json["relationship"];
    age = json["age"];
    fatherHusbandName = json["father_husband_name"];
    contactNumber = json["contact_number"];
    mobileNumber = json["mobile_number"];
    aadharNumber = json["aadhar_number"];
    profilePicture = json["profile_picture"];

    documents = json["documents"] != null
        ? List<KycGroup>.from(
        json["documents"].map((x) => KycGroup.fromJson(x)))
        : [];

    pendingKycForms = json["pending_kyc_forms"] != null
        ? List<KycGroup>.from(
        json["pending_kyc_forms"].map((x) => KycGroup.fromJson(x)))
        : [];
  }
}
