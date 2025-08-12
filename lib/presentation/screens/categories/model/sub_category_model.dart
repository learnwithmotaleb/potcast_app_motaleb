class SubCategoryModel {
  final bool? success;
  final String? message;
  final List<SubCategory>? data;

  SubCategoryModel({
    this.success,
    this.message,
    this.data,
  });

  SubCategoryModel copyWith({
    bool? success,
    String? message,
    List<SubCategory>? data,
  }) =>
      SubCategoryModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
      SubCategoryModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<SubCategory>.from(
                json["data"]!.map((x) => SubCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SubCategory {
  final String? id;
  final String? name;
  final String? image;
  final List<SubCategoryPodcast>? podcasts;

  SubCategory({
    this.id,
    this.name,
    this.image,
    this.podcasts,
  });

  SubCategory copyWith({
    String? id,
    String? name,
    String? image,
    List<SubCategoryPodcast>? podcasts,
  }) =>
      SubCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        podcasts: podcasts ?? this.podcasts,
      );

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["_id"],
        name: json["name"],
        image: json["image"],
        podcasts: json["podcasts"] == null
            ? []
            : List<SubCategoryPodcast>.from(
                json["podcasts"]!.map((x) => SubCategoryPodcast.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "image": image,
        "podcasts": podcasts == null
            ? []
            : List<dynamic>.from(podcasts!.map((x) => x.toJson())),
      };
}

class SubCategoryPodcast {
  final String? id;
  final Category? creator;
  final Category? category;
  final Category? subCategory;
  final String? coverImage;
  final String? podcastUrl;
  final String? title;
  final Location? location;
  final num? duration;
  final DateTime? createdAt;

  SubCategoryPodcast({
    this.id,
    this.creator,
    this.category,
    this.subCategory,
    this.coverImage,
    this.podcastUrl,
    this.title,
    this.location,
    this.duration,
    this.createdAt,
  });

  SubCategoryPodcast copyWith({
    String? id,
    Category? creator,
    Category? category,
    Category? subCategory,
    String? coverImage,
    String? podcastUrl,
    String? title,
    Location? location,
    num? duration,
    DateTime? createdAt,
  }) =>
      SubCategoryPodcast(
        id: id ?? this.id,
        creator: creator ?? this.creator,
        category: category ?? this.category,
        subCategory: subCategory ?? this.subCategory,
        coverImage: coverImage ?? this.coverImage,
        podcastUrl: podcastUrl ?? this.podcastUrl,
        title: title ?? this.title,
        location: location ?? this.location,
        duration: duration ?? this.duration,
        createdAt: createdAt ?? this.createdAt,
      );

  factory SubCategoryPodcast.fromJson(Map<String, dynamic> json) =>
      SubCategoryPodcast(
        id: json["_id"],
        creator:
            json["creator"] == null ? null : Category.fromJson(json["creator"]),
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        subCategory: json["subCategory"] == null
            ? null
            : Category.fromJson(json["subCategory"]),
        coverImage: json["coverImage"],
        podcastUrl: json["podcast_url"],
        title: json["title"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        duration: json["duration"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "creator": creator?.toJson(),
        "category": category?.toJson(),
        "subCategory": subCategory?.toJson(),
        "coverImage": coverImage,
        "podcast_url": podcastUrl,
        "title": title,
        "location": location?.toJson(),
        "duration": duration,
        "createdAt": createdAt?.toIso8601String(),
      };
}

class Category {
  final String? id;
  final String? name;

  Category({
    this.id,
    this.name,
  });

  Category copyWith({
    String? id,
    String? name,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class Location {
  final String? type;
  final List<num>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  Location copyWith({
    String? type,
    List<num>? coordinates,
  }) =>
      Location(
        type: type ?? this.type,
        coordinates: coordinates ?? this.coordinates,
      );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? []
            : List<num>.from(json["coordinates"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}
