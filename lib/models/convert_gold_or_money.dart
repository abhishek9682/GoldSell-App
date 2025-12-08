class GoldCalculationResponse {
  String? status;
  GoldCalculationData? data;

  GoldCalculationResponse({this.status, this.data});

  GoldCalculationResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    data = json["data"] != null && json["data"] is Map<String, dynamic>
        ? GoldCalculationData.fromJson(json["data"])
        : null;
  }


  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "data": data?.toJson(),
    };
  }
}

class GoldCalculationData {
  String? grams;
  String? grossAmount;
  String? gstAmount;
  String? gstPercentage;
  String? tdsAmount;
  String? tdsPercentage;
  String? tcsAmount;
  String? tcsPercentage;
  String? totalDeductions;
  String? netAmount;
  String? goldPricePerGram;

  GoldCalculationData({
    this.grams,
    this.grossAmount,
    this.gstAmount,
    this.gstPercentage,
    this.tdsAmount,
    this.tdsPercentage,
    this.tcsAmount,
    this.tcsPercentage,
    this.totalDeductions,
    this.netAmount,
    this.goldPricePerGram,
  });

  GoldCalculationData.fromJson(Map<String, dynamic> json) {
    grams = json["grams"];
    grossAmount = json["gross_amount"];
    gstAmount = json["gst_amount"];
    gstPercentage = json["gst_percentage"];
    tdsAmount = json["tds_amount"];
    tdsPercentage = json["tds_percentage"];
    tcsAmount = json["tcs_amount"];
    tcsPercentage = json["tcs_percentage"];
    totalDeductions = json["total_deductions"];
    netAmount = json["net_amount"];
    goldPricePerGram = json["gold_price_per_gram"];
  }

  Map<String, dynamic> toJson() {
    return {
      "grams": grams,
      "gross_amount": grossAmount,
      "gst_amount": gstAmount,
      "gst_percentage": gstPercentage,
      "tds_amount": tdsAmount,
      "tds_percentage": tdsPercentage,
      "tcs_amount": tcsAmount,
      "tcs_percentage": tcsPercentage,
      "total_deductions": totalDeductions,
      "net_amount": netAmount,
      "gold_price_per_gram": goldPricePerGram,
    };
  }
}
