class InvestmentPlansResponse {
  final String status;
  final PlansData data;

  InvestmentPlansResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'] ?? "",
        data = PlansData.fromJson(json['data'] ?? {});
}

class PlansData {
  final List<Plan> plans;
  final int totalPlans;

  PlansData.fromJson(Map<String, dynamic> json)
      : plans = (json['plans'] as List? ?? [])
      .map((item) => Plan.fromJson(item ?? {}))
      .toList(),
        totalPlans = json['total_plans'] ?? 0;
}

class Plan {
  final int id;
  final String name;
  final String slug;
  final String frequency;
  final String frequencyLabel;
  final String amount;
  final String formattedAmount;
  final String description;
  final List<String> features;
  final List<String> benefits;
  final String imageUrl;
  final bool isFeatured;
  final int sortOrder;
  final bool status;
  final int totalSubscribers;
  final int activeSubscribers;
  final bool isSubscribed;
  final dynamic userSubscriptionId;
  final dynamic userSubscriptionStatus;
  final String createdAt;

  Plan.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'] ?? "",
        slug = json['slug'] ?? "",
        frequency = json['frequency'] ?? "",
        frequencyLabel = json['frequency_label'] ?? "",
        amount = json['amount']?.toString() ?? "0",
        formattedAmount = json['formatted_amount'] ?? "",
        description = json['description'] ?? "",
        features = List<String>.from(json['features'] ?? []),
        benefits = List<String>.from(json['benefits'] ?? []),
        imageUrl = json['image_url'] ?? "",
        isFeatured = json['is_featured'] ?? false,
        sortOrder = json['sort_order'] ?? 0,
        status = json['status'] ?? false,
        totalSubscribers = json['total_subscribers'] ?? 0,
        activeSubscribers = json['active_subscribers'] ?? 0,
        isSubscribed = json['is_subscribed'],
        userSubscriptionId = json['user_subscription_id'],
        userSubscriptionStatus = json['user_subscription_status'],
        createdAt = json['created_at'] ?? "";

  void operator [](String other) {}
}
