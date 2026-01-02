class GoldLoanResponse {
  final String status;
  final GoldLoanData data;

  GoldLoanResponse({
    required this.status,
    required this.data,
  });

  factory GoldLoanResponse.fromJson(Map<String, dynamic> json) {
    return GoldLoanResponse(
      status: json['status'],
      data: GoldLoanData.fromJson(json['data']),
    );
  }
}

class GoldLoanData {
  final String message;
  final int enquiryId;

  GoldLoanData({
    required this.message,
    required this.enquiryId,
  });

  factory GoldLoanData.fromJson(Map<String, dynamic> json) {
    return GoldLoanData(
      message: json['message'],
      enquiryId: json['enquiry_id'],
    );
  }
}
