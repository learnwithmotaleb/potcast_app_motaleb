class BannerModel {
  final bool? success;
  final String? message;
  final List<BannerItem>? data;

  BannerModel({
    this.success,
    this.message,
    this.data,
  });

  BannerModel copyWith({
    bool? success,
    String? message,
    List<BannerItem>? data,
  }) =>
      BannerModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<BannerItem>.from(json["data"]!.map((x) => BannerItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class BannerItem {
  final String? id;
  final String? bannerUrl;
  final String? redirectUrl;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  BannerItem({
    this.id,
    this.bannerUrl,
    this.redirectUrl,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  BannerItem copyWith({
    String? id,
    String? bannerUrl,
    String? redirectUrl,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      BannerItem(
        id: id ?? this.id,
        bannerUrl: bannerUrl ?? this.bannerUrl,
        redirectUrl: redirectUrl ?? this.redirectUrl,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory BannerItem.fromJson(Map<String, dynamic> json) => BannerItem(
    id: json["_id"],
    bannerUrl: json["banner_url"],
    redirectUrl: json["redirect_url"],
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "banner_url": bannerUrl,
    "redirect_url": redirectUrl,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
