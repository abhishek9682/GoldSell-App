class BuyGoldResp {
  String? status;
  GoldCalculation? data;

  BuyGoldResp({this.status, this.data});

  BuyGoldResp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null
        ? GoldCalculation.fromJson(json['data'])
        : null;
  }
}

class GoldCalculation {
  String? amountEntered;
  String? goldGrams;
  String? goldValue;
  String? gstAmount;
  String? gstPercentage;
  String? tdsAmount;
  String? tdsPercentage;
  String? tcsAmount;
  String? tcsPercentage;
  String? totalTaxAmount;
  String? goldPricePerGram;

  GoldCalculation({
    this.amountEntered,
    this.goldGrams,
    this.goldValue,
    this.gstAmount,
    this.gstPercentage,
    this.tdsAmount,
    this.tdsPercentage,
    this.tcsAmount,
    this.tcsPercentage,
    this.totalTaxAmount,
    this.goldPricePerGram,
  });

  GoldCalculation.fromJson(Map<String, dynamic> json) {
    amountEntered = json['amount_entered'];
    goldGrams = json['gold_grams'];
    goldValue = json['gold_value'];
    gstAmount = json['gst_amount'];
    gstPercentage = json['gst_percentage'];
    tdsAmount = json['tds_amount'];
    tdsPercentage = json['tds_percentage'];
    tcsAmount = json['tcs_amount'];
    tcsPercentage = json['tcs_percentage'];
    totalTaxAmount = json['total_tax_amount'];
    goldPricePerGram = json['gold_price_per_gram'];
  }
}
