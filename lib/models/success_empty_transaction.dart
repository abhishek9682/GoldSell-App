class TransactionsListResponse {
  String? status;
  TransactionPagination? data;

  TransactionsListResponse({this.status, this.data});

  TransactionsListResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    data = json["data"] != null
        ? TransactionPagination.fromJson(json["data"])
        : null;
  }
}

class TransactionPagination {
  int? currentPage;
  List<Transaction>? transactions;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  int? perPage;
  int? to;
  int? total;

  TransactionPagination({
    this.currentPage,
    this.transactions,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.perPage,
    this.to,
    this.total,
  });

  TransactionPagination.fromJson(Map<String, dynamic> json) {
    currentPage = json["current_page"];
    transactions = json["data"] != null
        ? List<Transaction>.from(
        json["data"].map((x) => Transaction.fromJson(x)))
        : [];
    firstPageUrl = json["first_page_url"];
    from = json["from"];
    lastPage = json["last_page"];
    perPage = json["per_page"];
    to = json["to"];
    total = json["total"];
  }
}

class Transaction {
  // Add fields later once backend provides transaction object structure
  Transaction.fromJson(Map<String, dynamic> json) {
    // Assign fields here later
  }
}
