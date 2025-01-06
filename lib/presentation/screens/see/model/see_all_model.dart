class SeeAllModel {
  final bool? success;
  final String? message;
  final List<SeeAllPodcast>? data;

  SeeAllModel({
    this.success,
    this.message,
    this.data,
  });

  factory SeeAllModel.fromJson(Map<String, dynamic> json) => SeeAllModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<SeeAllPodcast>.from(json["data"]!.map((x) => SeeAllPodcast.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SeeAllPodcast {
  final String? id;
  final Category? category;
  final String? title;
  final String? cover;
  final String? audioDuration;
  final int? totalLikes;

  SeeAllPodcast({
    this.id,
    this.category,
    this.title,
    this.cover,
    this.audioDuration,
    this.totalLikes,
  });

  factory SeeAllPodcast.fromJson(Map<String, dynamic> json) => SeeAllPodcast(
    id: json["_id"],
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
    title: json["title"],
    cover: json["cover"],
    audioDuration: json["audioDuration"],
    totalLikes: json["totalLikes"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "category": category?.toJson(),
    "title": title,
    "cover": cover,
    "audioDuration": audioDuration,
    "totalLikes": totalLikes,
  };
}

class Category {
  final String? title;

  Category({
    this.title,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
  };
}
