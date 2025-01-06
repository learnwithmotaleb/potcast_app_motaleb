class SinglePodcastModel {
  final bool? success;
  final String? message;
  final Data? data;

  SinglePodcastModel({
    this.success,
    this.message,
    this.data,
  });

  factory SinglePodcastModel.fromJson(Map<String, dynamic> json) => SinglePodcastModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  final String? id;
/*  final Creator? creator;
  final Category? category;
  final Category? subCategory;*/
  final String? title;
  final String? description;
  final String? location;
  final String? cover;
/*  final String? coverFormat;
  final double? coverSize;
  final String? audio;
  final double? audioDuration;
  final String? audioFormat;
  final double? audioSize;
  final int? totalLikes;
  final int? totalViews;
  final int? totalComments;
  final int? totalFavorites;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;*/

  Data({
    this.id,
/*    this.creator,
    this.category,
    this.subCategory,*/
    this.title,
    this.description,
    this.location,
    this.cover,
/*    this.coverFormat,
    this.coverSize,
    this.audio,
    this.audioDuration,
    this.audioFormat,
    this.audioSize,
    this.totalLikes,
    this.totalViews,
    this.totalComments,
    this.totalFavorites,
    this.createdAt,
    this.updatedAt,
    this.v,*/
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
/*    creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
    subCategory: json["subCategory"] == null ? null : Category.fromJson(json["subCategory"]),*/
    title: json["title"],
    description: json["description"],
    location: json["location"],
    cover: json["cover"],
/*    coverFormat: json["coverFormat"],
    coverSize: json["coverSize"]?.toDouble(),
    audio: json["audio"],
    audioDuration: json["audioDuration"]?.toDouble(),
    audioFormat: json["audioFormat"],
    audioSize: json["audioSize"]?.toDouble(),
    totalLikes: json["totalLikes"],
    totalViews: json["totalViews"],
    totalComments: json["totalComments"],
    totalFavorites: json["totalFavorites"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],*/
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

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
  };
}

class Creator {
  final User? user;

  Creator({
    this.user,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
  };
}

class User {
  final String? name;

  User({
    this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
