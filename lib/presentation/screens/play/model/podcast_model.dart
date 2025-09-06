class PodcastModel {
  final bool? success;
  final String? message;
  final Data? data;

  PodcastModel({
    this.success,
    this.message,
    this.data,
  });

  factory PodcastModel.fromJson(Map<String, dynamic> json) => PodcastModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  final Podcast? podcast;
  final bool? isLiked;
  final bool? isFavorite;

  Data({
    this.podcast,
    this.isLiked,
    this.isFavorite,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        podcast:
            json["podcast"] == null ? null : Podcast.fromJson(json["podcast"]),
        isLiked: json["isLiked"],
        isFavorite: json["isFavorited"],
      );
}

class Podcast {
  final String? id;
  final Creator? creator;
  final Category? category;
  final String? title;
  final String? description;
  final String? location;
  final String? cover;
  final String? audio;

  Podcast({
    this.id,
    this.creator,
    this.category,
    this.title,
    this.description,
    this.location,
    this.cover,
    this.audio,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) => Podcast(
        id: json["_id"],
        creator:
            json["creator"] == null ? null : Creator.fromJson(json["creator"]),
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        title: json["title"],
        description: json["description"],
        location: json["location"],
        cover: json["cover"],
        audio: json["audio"],
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
  final String? donations;

  Creator({
    this.user,
    this.donations,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        donations: json["donations"],
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
