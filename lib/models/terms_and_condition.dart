class PrivacyPolicyResponse {
  final String status;
  final PrivacyPolicyData? data;

  PrivacyPolicyResponse({
    required this.status,
    this.data,
  });

  factory PrivacyPolicyResponse.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyResponse(
      status: json["status"] ?? "",
      data: json["data"] != null
          ? PrivacyPolicyData.fromJson(json["data"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "data": data?.toJson(),
    };
  }
}

class PrivacyPolicyData {
  final String title;
  final String content;
  final String lastUpdated;

  PrivacyPolicyData({
    required this.title,
    required this.content,
    required this.lastUpdated,
  });

  factory PrivacyPolicyData.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyData(
      title: json["title"] ?? "",
      content: json["content"] ?? "",
      lastUpdated: json["last_updated"] ?? "",
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
