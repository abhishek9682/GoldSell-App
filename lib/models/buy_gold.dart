class PaymentInitiationRequest {
  final String trxId;
  final String goldGrams;
  final String goldValue;
  final String gstAmount;
  final String gstPercentage;
  final String tdsAmount;
  final String tdsPercentage;
  final String tcsAmount;
  final String tcsPercentage;
  final String totalTaxAmount;
  final String amountToPay;
  final String payableAmount;
  final String currency;
  final String message;

  PaymentInitiationRequest({
    required this.trxId,
    required this.goldGrams,
    required this.goldValue,
    required this.gstAmount,
    required this.gstPercentage,
    required this.tdsAmount,
    required this.tdsPercentage,
    required this.tcsAmount,
    required this.tcsPercentage,
    required this.totalTaxAmount,
    required this.amountToPay,
    required this.payableAmount,
    required this.currency,
    required this.message,
  });

  factory PaymentInitiationRequest.fromjson(Map<String, dynamic> json) {
    final data = json["data"];

    return PaymentInitiationRequest(
      trxId: data["trx_id"],
      goldGrams: data["gold_grams"],
      goldValue: data["gold_value"],
      gstAmount: data["gst_amount"],
      gstPercentage: data["gst_percentage"],
      tdsAmount: data["tds_amount"],
      tdsPercentage: data["tds_percentage"],
      tcsAmount: data["tcs_amount"],
      tcsPercentage: data["tcs_percentage"],
      totalTaxAmount: data["total_tax_amount"],
      amountToPay: data["amount_to_pay"],
      payableAmount: data["payable_amount"],
      currency: data["currency"],
      message: data["message"],
    );
  }
}
