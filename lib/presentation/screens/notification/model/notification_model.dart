class NotificationModel {
  final bool? success;
  final String? message;
  final Data? data;

  NotificationModel({
    this.success,
    this.message,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  final List<NotificationData>? notifications;

  Data({
    this.notifications,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    notifications: json["notifications"] == null ? [] : List<NotificationData>.from(json["notifications"]!.map((x) => NotificationData.fromJson(x))),
  );
}

class NotificationData {
  final String? subject;
  final String? podcast;
  final String? message;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? id;

  NotificationData({
    this.subject,
    this.podcast,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    subject: json["subject"],
    podcast: json["podcast"],
    message: json["message"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    id: json["_id"],
  );
}
