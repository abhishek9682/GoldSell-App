class NotificationResponse {
  String? status;
  List<NotificationData>? data;

  NotificationResponse({
    this.status,
    this.data,
  });

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    if (json["data"] != null) {
      data = List<NotificationData>.from(
        json["data"].map((x) => NotificationData.fromJson(x)),
      );
    }
  }
}

class NotificationData {
  int? id;
  int? inAppNotificationableId;
  String? inAppNotificationableType;
  NotificationDescription? description;
  String? createdAt;
  String? updatedAt;
  String? formattedDate;

  NotificationData({
    this.id,
    this.inAppNotificationableId,
    this.inAppNotificationableType,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.formattedDate,
  });

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    inAppNotificationableId = json["in_app_notificationable_id"];
    inAppNotificationableType = json["in_app_notificationable_type"];
    description = json["description"] != null
        ? NotificationDescription.fromJson(json["description"])
        : null;
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    formattedDate = json["formatted_date"];
  }
}

class NotificationDescription {
  String? text;
  String? link;
  String? icon;

  NotificationDescription({
    this.text,
    this.link,
    this.icon,
  });

  NotificationDescription.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    link = json["link"];
    icon = json["icon"];
  }
}
