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
}

class SeeAllPodcast {
  final String? id;
  final dynamic category;
  final String? title;
  final String? cover;
  final String? audioDuration;

  SeeAllPodcast({
    this.id,
    this.category,
    this.title,
    this.cover,
    this.audioDuration,
  });

  factory SeeAllPodcast.fromJson(Map<String, dynamic> json) => SeeAllPodcast(
    id: json["_id"],
    category: json["category"],
    title: json["title"],
    cover: json["cover"],
    audioDuration: json["audioDuration"],
  );
}
