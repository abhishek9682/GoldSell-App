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
  final String goldBalance;          // ✔ string
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

  // 🔥 SUPER SAFE number cleaner
  static double cleanDouble(dynamic value) {
    if (value == null) return 0.0;
    return double.tryParse(value.toString().replaceAll(",", "")) ?? 0.0;
  }

  factory GoldPurchaseData.fromJson(Map<String, dynamic> json) {
    return GoldPurchaseData(
      trxId: json['trx_id']?.toString() ?? '',
      goldGramsPurchased: cleanDouble(json['gold_grams']),
      goldBalance: json['gold_balance']?.toString() ?? "0",   // ✔ now string
      goldValue: cleanDouble(json['gold_value']),
      gstAmount: cleanDouble(json['gst_amount']),
      tdsAmount: cleanDouble(json['tds_amount']),
      tcsAmount: cleanDouble(json['tcs_amount']),
      totalTaxAmount: cleanDouble(json['total_tax_amount']),
      amountPaid: cleanDouble(json['total_amount']),          // ✔ FIXED
      message: json['message']?.toString() ?? '',
    );
  }
}
