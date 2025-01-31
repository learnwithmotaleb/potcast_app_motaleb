class HomeModel {
  final bool? success;
  final String? message;
  final Data? data;

  HomeModel({
    this.success,
    this.message,
    this.data,
  });

  HomeModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      HomeModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
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
  final dynamic location;
  final List<CategoryElement>? categories;
  final dynamic admin;
  final List<Creator>? creators;
  final List<Podcast>? newPodcasts;
  final List<Podcast>? popularPodcasts;
  final List<Podcast>? shortPodcasts;

  Data({
    this.location,
    this.categories,
    this.admin,
    this.creators,
    this.newPodcasts,
    this.popularPodcasts,
    this.shortPodcasts,
  });

  Data copyWith({
    dynamic location,
    List<CategoryElement>? categories,
    dynamic admin,
    List<Creator>? creators,
    List<Podcast>? newPodcasts,
    List<Podcast>? popularPodcasts,
    List<Podcast>? shortPodcasts,
  }) =>
      Data(
        location: location ?? this.location,
        categories: categories ?? this.categories,
        admin: admin ?? this.admin,
        creators: creators ?? this.creators,
        newPodcasts: newPodcasts ?? this.newPodcasts,
        popularPodcasts: popularPodcasts ?? this.popularPodcasts,
        shortPodcasts: shortPodcasts ?? this.shortPodcasts,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    location: json["location"],
    categories: json["categories"] == null ? [] : List<CategoryElement>.from(json["categories"]!.map((x) => CategoryElement.fromJson(x))),
    admin: json["admin"],
    creators: json["creators"] == null ? [] : List<Creator>.from(json["creators"]!.map((x) => Creator.fromJson(x))),
    newPodcasts: json["newPodcasts"] == null ? [] : List<Podcast>.from(json["newPodcasts"]!.map((x) => Podcast.fromJson(x))),
    popularPodcasts: json["popularPodcasts"] == null ? [] : List<Podcast>.from(json["popularPodcasts"]!.map((x) => Podcast.fromJson(x))),
    shortPodcasts: json["shortPodcasts"] == null ? [] : List<Podcast>.from(json["shortPodcasts"]!.map((x) => Podcast.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "location": location,
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "admin": admin,
    "creators": creators == null ? [] : List<dynamic>.from(creators!.map((x) => x.toJson())),
    "newPodcasts": newPodcasts == null ? [] : List<dynamic>.from(newPodcasts!.map((x) => x.toJson())),
    "popularPodcasts": popularPodcasts == null ? [] : List<dynamic>.from(popularPodcasts!.map((x) => x.toJson())),
    "shortPodcasts": shortPodcasts == null ? [] : List<dynamic>.from(shortPodcasts!.map((x) => x.toJson())),
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

  CategoryElement copyWith({
    String? id,
    String? title,
    String? categoryImage,
  }) =>
      CategoryElement(
        id: id ?? this.id,
        title: title ?? this.title,
        categoryImage: categoryImage ?? this.categoryImage,
      );

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

class Creator {
  final String? podcast;
  final String? name;
  final String? avatar;

  Creator({
    this.podcast,
    this.name,
    this.avatar,
  });

  Creator copyWith({
    String? podcast,
    String? name,
    String? avatar,
  }) =>
      Creator(
        podcast: podcast ?? this.podcast,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
      );

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
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

class Podcast {
  final String? id;
  final NewPodcastCategory? category;
  final String? title;
  final String? cover;
  final String? audioDuration;

  Podcast({
    this.id,
    this.category,
    this.title,
    this.cover,
    this.audioDuration,
  });

  Podcast copyWith({
    String? id,
    NewPodcastCategory? category,
    String? title,
    String? cover,
    String? audioDuration,
  }) =>
      Podcast(
        id: id ?? this.id,
        category: category ?? this.category,
        title: title ?? this.title,
        cover: cover ?? this.cover,
        audioDuration: audioDuration ?? this.audioDuration,
      );

  factory Podcast.fromJson(Map<String, dynamic> json) => Podcast(
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

  NewPodcastCategory copyWith({
    String? title,
  }) =>
      NewPodcastCategory(
        title: title ?? this.title,
      );

  factory NewPodcastCategory.fromJson(Map<String, dynamic> json) => NewPodcastCategory(
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
  };
}
