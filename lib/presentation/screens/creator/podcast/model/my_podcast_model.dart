class MyPodcastModel {
  final bool? success;
  final String? message;
  final List<MyPodcastData>? data;
  final Pagination? pagination;

  MyPodcastModel({
    this.success,
    this.message,
    this.data,
    this.pagination,
  });

  factory MyPodcastModel.fromJson(Map<String, dynamic> json) => MyPodcastModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<MyPodcastData>.from(
                json["data"]!.map((x) => MyPodcastData.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );
}

class MyPodcastData {
  final String? id;
  final Creator? creator;
  final Category? category;
  final Category? subCategory;
  final String? title;
  final String? description;
  final String? location;
  final String? cover;
  final String? coverFormat;
  final num? coverSize;
  final String? audio;
  final String? audioDuration;
  final String? audioFormat;
  final num? audioSize;
  final num? totalLikes;
  final num? totalViews;
  final num? totalComments;
  final num? totalFavorites;

  MyPodcastData({
    this.id,
    this.creator,
    this.category,
    this.subCategory,
    this.title,
    this.description,
    this.location,
    this.cover,
    this.coverFormat,
    this.coverSize,
    this.audio,
    this.audioDuration,
    this.audioFormat,
    this.audioSize,
    this.totalLikes,
    this.totalViews,
    this.totalComments,
    this.totalFavorites,
  });

  factory MyPodcastData.fromJson(Map<String, dynamic> json) => MyPodcastData(
        id: json["_id"],
        creator:
            json["creator"] == null ? null : Creator.fromJson(json["creator"]),
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        subCategory: json["subCategory"] == null
            ? null
            : Category.fromJson(json["subCategory"]),
        title: json["title"],
        description: json["description"],
        location: json["location"],
        cover: json["cover"],
        coverFormat: json["coverFormat"],
        coverSize: json["coverSize"],
        audio: json["audio"],
        audioDuration: json["audioDuration"],
        audioFormat: json["audioFormat"],
        audioSize: json["audioSize"],
        totalLikes: json["totalLikes"],
        totalViews: json["totalViews"],
        totalComments: json["totalComments"],
        totalFavorites: json["totalFavorites"],
      );
}

class Category {
  final String? id;
  final String? title;

  Category({
    this.id,
    this.title,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        title: json["title"],
      );
}

class Creator {
  final User? user;

  Creator({
    this.user,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );
}

class User {
  final String? name;

  User({
    this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
      );
}

class Pagination {
  final num? page;
  final num? limit;
  final num? total;

  Pagination({
    this.page,
    this.limit,
    this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        limit: json["limit"],
        total: json["total"],
      );
}
