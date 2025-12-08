class GoldSellResponse {
  String? status; GoldSellData? data;
  GoldSellResponse({this.status, this.data});
  GoldSellResponse.fromJson(Map<String, dynamic> json)
  {
    status = json["status"]; data = json["data"] != null ? GoldSellData.fromJson(json["data"]) : null;
  }
}

class GoldSellData {
  String? trxId;
  String? goldGramsSold;
  String? goldBalanceRemaining;
  String? grossAmount;
  String? gstAmount;
  String? gstPercentage;
  String? tdsAmount;
  String? tdsPercentage;
  String? tcsAmount;
  String? tcsPercentage;
  String? totalDeductions;
  String? netAmount;
  String? payoutMethod;
  String? paymentMethod;
  String? status;
  String? message;

  GoldSellData({
    this.trxId,
    this.goldGramsSold,
    this.goldBalanceRemaining,
    this.grossAmount,
    this.gstAmount,
    this.gstPercentage,
    this.tdsAmount,
    this.tdsPercentage,
    this.tcsAmount,
    this.tcsPercentage,
    this.totalDeductions,
    this.netAmount,
    this.payoutMethod,
    this.paymentMethod,
    this.status,
    this.message,
  });

  GoldSellData.fromJson(Map<String, dynamic> json) {
    trxId = json["trx_id"];
    goldGramsSold = json["gold_grams_sold"];
    goldBalanceRemaining = json["gold_balance_remaining"];
    grossAmount = json["gross_amount"];
    gstAmount = json["gst_amount"];
    gstPercentage = json["gst_percentage"];
    tdsAmount = json["tds_amount"];
    tdsPercentage = json["tds_percentage"];
    tcsAmount = json["tcs_amount"];
    tcsPercentage = json["tcs_percentage"];
    totalDeductions = json["total_deductions"];
    netAmount = json["net_amount"];
    payoutMethod = json["payout_method"];
    paymentMethod = json["payment_method"];
    status = json["status"];
    message = json["message"];
  }
}
