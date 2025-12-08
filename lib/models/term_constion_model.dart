class TermsConditionsModel {
  final String status;
  final TermsData? data;

  TermsConditionsModel({
    required this.status,
    this.data,
  });

  factory TermsConditionsModel.fromJson(Map<String, dynamic> json) {
    return TermsConditionsModel(
      status: json['status'] ?? "",
      data: json['data'] != null ? TermsData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "data": data?.toJson(),
    };
  }
}

class TermsData {
  final String title;
  final String content; // HTML String
  final String lastUpdated;

  TermsData({
    required this.title,
    required this.content,
    required this.lastUpdated,
  });

  factory TermsData.fromJson(Map<String, dynamic> json) {
    return TermsData(
      title: json['title'] ?? "",
      content: json['content'] ?? "",
      lastUpdated: json['last_updated'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "content": content,
      "last_updated": lastUpdated,
    };
  }
}
