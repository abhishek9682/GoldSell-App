class GoldPurchaseResponse {
  final String status;
  final GoldPurchaseData? data;

  GoldPurchaseResponse({
    required this.status,
    this.data,
  });

  factory GoldPurchaseResponse.fromJson(Map<String, dynamic> json) {
    return GoldPurchaseResponse(
      status: json['status'] ?? '',
      data: json['data'] != null
          ? GoldPurchaseData.fromJson(json['data'])
          : null,
    );
  }
}

class GoldPurchaseData {
  final String trxId;
  final double goldGramsPurchased;
  final double goldBalance;
  final double goldValue;
  final double gstAmount;
  final double tdsAmount;
  final double tcsAmount;
  final double totalTaxAmount;
  final double amountPaid;
  final String message;

  GoldPurchaseData({
    required this.trxId,
    required this.goldGramsPurchased,
    required this.goldBalance,
    required this.goldValue,
    required this.gstAmount,
    required this.tdsAmount,
    required this.tcsAmount,
    required this.totalTaxAmount,
    required this.amountPaid,
    required this.message,
  });

  factory GoldPurchaseData.fromJson(Map<String, dynamic> json) {
    return GoldPurchaseData(
      trxId: json['trx_id']?.toString() ?? '',
      goldGramsPurchased: double.tryParse(json['gold_grams_purchased']?.toString() ?? '0') ?? 0.0,
      goldBalance: double.tryParse(json['gold_balance']?.toString() ?? '0') ?? 0.0,
      goldValue: double.tryParse(json['gold_value']?.toString() ?? '0') ?? 0.0,
      gstAmount: double.tryParse(json['gst_amount']?.toString() ?? '0') ?? 0.0,
      tdsAmount: double.tryParse(json['tds_amount']?.toString() ?? '0') ?? 0.0,
      tcsAmount: double.tryParse(json['tcs_amount']?.toString() ?? '0') ?? 0.0,
      totalTaxAmount: double.tryParse(json['total_tax_amount']?.toString() ?? '0') ?? 0.0,
      amountPaid: double.tryParse(json['amount_paid']?.toString() ?? '0') ?? 0.0,
      message: json['message']?.toString() ?? '',
    );
  }

}
