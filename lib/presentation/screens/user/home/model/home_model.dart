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
  final List<CategoryElement>? categories;
  final List<Creator>? creators;
  final List<Podcast>? newPodcasts;
  final List<Podcast>? popularPodcasts;

  Data({
    this.categories,
    this.creators,
    this.newPodcasts,
    this.popularPodcasts,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    categories: json["categories"] == null ? [] : List<CategoryElement>.from(json["categories"]!.map((x) => CategoryElement.fromJson(x))),
    creators: json["creators"] == null ? [] : List<Creator>.from(json["creators"]!.map((x) => Creator.fromJson(x))),
    newPodcasts: json["newPodcasts"] == null ? [] : List<Podcast>.from(json["newPodcasts"]!.map((x) => Podcast.fromJson(x))),
    popularPodcasts: json["popularPodcasts"] == null ? [] : List<Podcast>.from(json["popularPodcasts"]!.map((x) => Podcast.fromJson(x))),
  );
}

class CategoryElement {
  final String? id;
  final String? title;
  final String? image;

  CategoryElement({
    this.id,
    this.title,
    this.image,
  });

  factory CategoryElement.fromJson(Map<String, dynamic> json) => CategoryElement(
    id: json["_id"],
    title: json["title"],
    image: json["image"],
  );
}

class Creator {
  final String? id;
  final User? user;

  Creator({
    this.id,
    this.user,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
    id: json["_id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );
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

  factory Podcast.fromJson(Map<String, dynamic> json) => Podcast(
    id: json["_id"],
    category: json["category"] == null ? null : NewPodcastCategory.fromJson(json["category"]),
    title: json["title"],
    cover: json["cover"],
    audioDuration: json["audioDuration"],
  );
}

class NewPodcastCategory {
  final String? title;

  NewPodcastCategory({
    this.title,
  });

  factory NewPodcastCategory.fromJson(Map<String, dynamic> json) => NewPodcastCategory(
    title: json["title"],
  );
}
