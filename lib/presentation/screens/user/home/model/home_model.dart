class HomeModel {
  final bool? success;
  final String? message;
  final Data? data;

  HomeModel({
    this.success,
    this.message,
    this.data,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  final String? location;
  final List<CategoryElement>? categories;
  final Admin? admin;
  final List<Admin>? creators;
  final List<NewPodcastElement>? newPodcasts;
  final List<NewPodcastElement>? popularPodcasts;

  Data({
    this.location,
    this.categories,
    this.admin,
    this.creators,
    this.newPodcasts,
    this.popularPodcasts,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    location: json["location"],
    categories: json["categories"] == null ? [] : List<CategoryElement>.from(json["categories"]!.map((x) => CategoryElement.fromJson(x))),
    admin: json["admin"] == null ? null : Admin.fromJson(json["admin"]),
    creators: json["creators"] == null ? [] : List<Admin>.from(json["creators"]!.map((x) => Admin.fromJson(x))),
    newPodcasts: json["newPodcasts"] == null ? [] : List<NewPodcastElement>.from(json["newPodcasts"]!.map((x) => NewPodcastElement.fromJson(x))),
    popularPodcasts: json["popularPodcasts"] == null ? [] : List<NewPodcastElement>.from(json["popularPodcasts"]!.map((x) => NewPodcastElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "location": location,
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "admin": admin?.toJson(),
    "creators": creators == null ? [] : List<dynamic>.from(creators!.map((x) => x.toJson())),
    "newPodcasts": newPodcasts == null ? [] : List<dynamic>.from(newPodcasts!.map((x) => x.toJson())),
    "popularPodcasts": popularPodcasts == null ? [] : List<dynamic>.from(popularPodcasts!.map((x) => x.toJson())),
  };
}

class Admin {
  final String? name;
  final String? avatar;
  final String? podcast;

  Admin({
    this.name,
    this.avatar,
    this.podcast,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    name: json["name"],
    avatar: json["avatar"],
    podcast: json["podcast"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "avatar": avatar,
    "podcast": podcast,
  };
}

class CategoryElement {
  final String? id;
  final String? title;
  final String? categoryImage;

  CategoryElement({
    this.id,
    this.title,
    this.categoryImage,
  });

  factory CategoryElement.fromJson(Map<String, dynamic> json) => CategoryElement(
    id: json["_id"],
    title: json["title"],
    categoryImage: json["categoryImage"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "categoryImage": categoryImage,
  };
}

class NewPodcastElement {
  final String? id;
  final NewPodcastCategory? category;
  final String? title;
  final String? cover;
  final String? audioDuration;

  NewPodcastElement({
    this.id,
    this.category,
    this.title,
    this.cover,
    this.audioDuration,
  });

  factory NewPodcastElement.fromJson(Map<String, dynamic> json) => NewPodcastElement(
    id: json["_id"],
    category: json["category"] == null ? null : NewPodcastCategory.fromJson(json["category"]),
    title: json["title"],
    cover: json["cover"],
    audioDuration: json["audioDuration"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "category": category?.toJson(),
    "title": title,
    "cover": cover,
    "audioDuration": audioDuration,
  };
}

class NewPodcastCategory {
  final String? title;

  NewPodcastCategory({
    this.title,
  });

  factory NewPodcastCategory.fromJson(Map<String, dynamic> json) => NewPodcastCategory(
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
  };
}
