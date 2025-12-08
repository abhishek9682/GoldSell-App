class HelpCenterResponse {
  String? status;
  HelpCenterData? data;

  HelpCenterResponse({this.status, this.data});

  HelpCenterResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? HelpCenterData.fromJson(json['data']) : null;
  }
}

class HelpCenterData {
  String? title;
  List<Faq>? faqs;
  String? lastUpdated;

  HelpCenterData({this.title, this.faqs, this.lastUpdated});

  HelpCenterData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    lastUpdated = json['last_updated'];
    if (json['faqs'] != null) {
      faqs = List<Faq>.from(json['faqs'].map((x) => Faq.fromJson(x)));
    }
  }
}

class Faq {
  String? question;
  String? answer;

  Faq({this.question, this.answer});

  Faq.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
  }
}
