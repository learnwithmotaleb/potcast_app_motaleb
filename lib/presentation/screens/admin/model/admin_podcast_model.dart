/*
class AdminPodcastModel {
  final bool? success;
  final String? message;
  final Data? data;

  AdminPodcastModel({
    this.success,
    this.message,
    this.data,
  });

  factory AdminPodcastModel.fromJson(Map<String, dynamic> json) => AdminPodcastModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final List<AdminPodcast>? podcasts;

  Data({
    this.podcasts,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    podcasts: json["podcasts"] == null ? [] : List<AdminPodcast>.from(json["podcasts"]!.map((x) => AdminPodcast.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "podcasts": podcasts == null ? [] : List<dynamic>.from(podcasts!.map((x) => x.toJson())),
  };
}

class AdminPodcast {
  final String? id;
  final Creator? creator;
  final Category? category;
  final String? title;
  final String? cover;
  final String? audioDuration;

  AdminPodcast({
    this.id,
    this.creator,
    this.category,
    this.title,
    this.cover,
    this.audioDuration,
  });

  factory AdminPodcast.fromJson(Map<String, dynamic> json) => AdminPodcast(
    id: json["_id"],
    creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
    title: json["title"],
    cover: json["cover"],
    audioDuration: json["audioDuration"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "creator": creator?.toJson(),
    "category": category?.toJson(),
    "title": title,
    "cover": cover,
    "audioDuration": audioDuration,
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
*/
