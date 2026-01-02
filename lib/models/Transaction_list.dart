// 📌 Full Transaction API Model — Matches API Structure Exactly

class TransactionResponse {
  String? status;
  TransactionPageData? data;

  TransactionResponse({this.status, this.data});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      status: json["status"],
      data: json["data"] != null
          ? TransactionPageData.fromJson(json["data"])
          : null,
    );
  }
}

// -------------------------------------------------------------

class TransactionPageData {
  List<TransactionItem>? transactions;
  TransactionLinks? links;
  TransactionMeta? meta;

  TransactionPageData({this.transactions, this.links, this.meta});

  factory TransactionPageData.fromJson(Map<String, dynamic> json) {
    return TransactionPageData(
      transactions: json["data"] != null
          ? List<TransactionItem>.from(
        json["data"].map((x) => TransactionItem.fromJson(x)),
      )
          : [],
      links:
      json["links"] != null ? TransactionLinks.fromJson(json["links"]) : null,
      meta: json["meta"] != null ? TransactionMeta.fromJson(json["meta"]) : null,
    );
  }
}

// -------------------------------------------------------------

class TransactionItem {
  int? id;
  double? amount;
  double? charge;
  String? trxType;
  String? transactionType;
  String? trxId;
  String? remarks;
  String? createdAt;
  String? baseCurrency;
  String? currencySymbol;

  TransactionItem({
    this.id,
    this.amount,
    this.charge,
    this.trxType,
    this.transactionType,
    this.trxId,
    this.remarks,
    this.createdAt,
    this.baseCurrency,
    this.currencySymbol,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      id: json["id"],
      amount: double.tryParse(json["amount"].toString()) ?? 0.0,
      charge: double.tryParse(json["charge"].toString()) ?? 0.0,
      trxType: json["trx_type"],
      transactionType: json["transaction_type"],
      trxId: json["trx_id"],
      remarks: json["remarks"],
      createdAt: json["created_at"],
      baseCurrency: json["base_currency"],
      currencySymbol: json["currency_symbol"],
    );
  }
}

// -------------------------------------------------------------

class TransactionLinks {
  String? first;
  String? last;
  String? prev;
  String? next;

  TransactionLinks({this.first, this.last, this.prev, this.next});

  factory TransactionLinks.fromJson(Map<String, dynamic> json) {
    return TransactionLinks(
      first: json["first"],
      last: json["last"],
      prev: json["prev"],
      next: json["next"],
    );
  }
}

// -------------------------------------------------------------

class TransactionMeta {
  int? currentPage;
  int? from;
  int? lastPage;
  int? perPage;
  int? to;
  int? total;
  String? path;

  TransactionMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.perPage,
    this.to,
    this.total,
    this.path,
  });

  factory TransactionMeta.fromJson(Map<String, dynamic> json) {
    return TransactionMeta(
      currentPage: json["current_page"],
      from: json["from"],
      lastPage: json["last_page"],
      perPage: json["per_page"],
      to: json["to"],
      total: json["total"],
      path: json["path"],
    );
  }
}
