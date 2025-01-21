class TopCreatorModel {
  final bool? success;
  final List<CreatorData>? data;
  final int? page;
  final int? limit;

  TopCreatorModel({
    this.success,
    this.data,
    this.page,
    this.limit,
  });

  factory TopCreatorModel.fromJson(Map<String, dynamic> json) => TopCreatorModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<CreatorData>.from(json["data"]!.map((x) => CreatorData.fromJson(x))),
    page: json["page"],
    limit: json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "page": page,
    "limit": limit,
  };
}

class CreatorData {
  final String? podcast;
  final String? name;
  final dynamic avatar;

  CreatorData({
    this.podcast,
    this.name,
    this.avatar,
  });

  factory CreatorData.fromJson(Map<String, dynamic> json) => CreatorData(
    podcast: json["podcast"],
    name: json["name"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "podcast": podcast,
    "name": name,
    "avatar": avatar,
  };
}
