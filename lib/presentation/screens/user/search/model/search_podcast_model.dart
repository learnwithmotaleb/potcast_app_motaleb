class SearchPodcastModel {
  final bool? success;
  final String? message;
  final Data? data;

  SearchPodcastModel({
    this.success,
    this.message,
    this.data,
  });

  factory SearchPodcastModel.fromJson(Map<String, dynamic> json) => SearchPodcastModel(
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
  final List<SearchPodcast>? podcasts;
  final int? page;
  final int? limit;
  final int? total;

  Data({
    this.podcasts,
    this.page,
    this.limit,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    podcasts: json["podcasts"] == null ? [] : List<SearchPodcast>.from(json["podcasts"]!.map((x) => SearchPodcast.fromJson(x))),
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "podcasts": podcasts == null ? [] : List<dynamic>.from(podcasts!.map((x) => x.toJson())),
    "page": page,
    "limit": limit,
    "total": total,
  };
}

class SearchPodcast {
  final String? id;
  final Creator? creator;
  final Category? category;
  final Category? subCategory;
  final String? title;
  final String? description;
  final String? location;
  final String? audio;
  final int? totalLikes;
  final int? totalViews;
  final String? audioDuration;

  SearchPodcast({
    this.id,
    this.creator,
    this.category,
    this.subCategory,
    this.title,
    this.description,
    this.location,
    this.audio,
    this.totalLikes,
    this.totalViews,
    this.audioDuration,
  });

  factory SearchPodcast.fromJson(Map<String, dynamic> json) => SearchPodcast(
    id: json["_id"],
    creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
    subCategory: json["subCategory"] == null ? null : Category.fromJson(json["subCategory"]),
    title: json["title"],
    description: json["description"],
    location: json["location"],
    audio: json["audio"],
    totalLikes: json["totalLikes"],
    totalViews: json["totalViews"],
    audioDuration: json["audioDuration"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "creator": creator?.toJson(),
    "category": category?.toJson(),
    "subCategory": subCategory?.toJson(),
    "title": title,
    "description": description,
    "location": location,
    "audio": audio,
    "totalLikes": totalLikes,
    "totalViews": totalViews,
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
  final String? avatar;

  User({
    this.name,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "avatar": avatar,
  };
}
