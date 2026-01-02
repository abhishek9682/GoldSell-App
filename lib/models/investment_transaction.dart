class TransactionsResponse {
  String? status;
  TransactionsData? data;

  TransactionsResponse({this.status, this.data});

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) {
    return TransactionsResponse(
      status: json['status'],
      data: json['data'] != null
          ? TransactionsData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.toJson(),
    };
  }
}

class TransactionsData {
  List<TransactionItem>? transactions;
  Pagination? pagination;

  TransactionsData({this.transactions, this.pagination});

  factory TransactionsData.fromJson(Map<String, dynamic> json) {
    return TransactionsData(
      transactions: json['transactions'] != null
          ? (json['transactions'] as List)
          .map((e) => TransactionItem.fromJson(e))
          .toList()
          : [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactions': transactions?.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class TransactionItem {
  int? id;
  int? subscriptionId;
  Subscription? subscription;
  Plan? plan;
  String? transactionDate;
  String? amountDeducted;
  String? formattedAmount;
  String? goldGramsCredited;
  String? goldPriceAtTransaction;
  BankAccount? bankAccount;
  String? status;
  String? failureReason;
  String? transactionId;
  String? createdAt;

  TransactionItem({
    this.id,
    this.subscriptionId,
    this.subscription,
    this.plan,
    this.transactionDate,
    this.amountDeducted,
    this.formattedAmount,
    this.goldGramsCredited,
    this.goldPriceAtTransaction,
    this.bankAccount,
    this.status,
    this.failureReason,
    this.transactionId,
    this.createdAt,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      id: json['id'],
      subscriptionId: json['subscription_id'],
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'])
          : null,
      plan: json['plan'] != null ? Plan.fromJson(json['plan']) : null,
      transactionDate: json['transaction_date'],
      amountDeducted: json['amount_deducted'],
      formattedAmount: json['formatted_amount'],
      goldGramsCredited: json['gold_grams_credited'],
      goldPriceAtTransaction: json['gold_price_at_transaction'],
      bankAccount: json['bank_account'] != null
          ? BankAccount.fromJson(json['bank_account'])
          : null,
      status: json['status'],
      failureReason: json['failure_reason'],
      transactionId: json['transaction_id'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subscription_id': subscriptionId,
      'subscription': subscription?.toJson(),
      'plan': plan?.toJson(),
      'transaction_date': transactionDate,
      'amount_deducted': amountDeducted,
      'formatted_amount': formattedAmount,
      'gold_grams_credited': goldGramsCredited,
      'gold_price_at_transaction': goldPriceAtTransaction,
      'bank_account': bankAccount?.toJson(),
      'status': status,
      'failure_reason': failureReason,
      'transaction_id': transactionId,
      'created_at': createdAt,
    };
  }
}

class Subscription {
  int? id;
  String? investmentAmount;
  String? frequency;
  String? status;

  Subscription({
    this.id,
    this.investmentAmount,
    this.frequency,
    this.status,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      investmentAmount: json['investment_amount'],
      frequency: json['frequency'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'investment_amount': investmentAmount,
      'frequency': frequency,
      'status': status,
    };
  }
}

class Plan {
  int? id;
  String? name;
  String? slug;
  String? frequency;
  String? imageUrl;

  Plan({
    this.id,
    this.name,
    this.slug,
    this.frequency,
    this.imageUrl,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      frequency: json['frequency'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'frequency': frequency,
      'image_url': imageUrl,
    };
  }
}

class BankAccount {
  int? id;
  String? bankName;
  String? accountNumber;

  BankAccount({
    this.id,
    this.bankName,
    this.accountNumber,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'],
      bankName: json['bank_name'],
      accountNumber: json['account_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bank_name': bankName,
      'account_number': accountNumber,
    };
  }
}

class Pagination {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;

  Pagination({
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      perPage: json['per_page'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'per_page': perPage,
      'current_page': currentPage,
      'last_page': lastPage,
    };
  }
}
