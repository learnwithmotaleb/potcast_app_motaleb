class PlayListSongsModel {
  final bool? success;
  final String? message;
  final Data? data;

  PlayListSongsModel({
    this.success,
    this.message,
    this.data,
  });

  factory PlayListSongsModel.fromJson(Map<String, dynamic> json) => PlayListSongsModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  final List<PlayListPodcast>? podcasts;

  Data({
    this.podcasts,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    podcasts: json["podcasts"] == null ? [] : List<PlayListPodcast>.from(json["podcasts"]!.map((x) => PlayListPodcast.fromJson(x))),
  );
}

class PlayListPodcast {
  final String? id;
  final Creator? creator;
  final Category? category;
  final String? title;
  final String? cover;
  final String? audioDuration;

  PlayListPodcast({
    this.id,
    this.creator,
    this.category,
    this.title,
    this.cover,
    this.audioDuration,
  });

  factory PlayListPodcast.fromJson(Map<String, dynamic> json) => PlayListPodcast(
    id: json["_id"],
    creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
    title: json["title"],
    cover: json["cover"],
    audioDuration: json["audioDuration"],
  );
}

class Category {
  final String? title;

  Category({
    this.title,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
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
