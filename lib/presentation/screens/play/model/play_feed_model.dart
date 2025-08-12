class PlayFeedModel {
  final bool? success;
  final String? message;
  final Data? data;

  PlayFeedModel({
    this.success,
    this.message,
    this.data,
  });

  PlayFeedModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      PlayFeedModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory PlayFeedModel.fromJson(Map<String, dynamic> json) => PlayFeedModel(
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
  final List<PlayPodcastItem>? podcasts;
  final String? nextCursor;
  final bool? hasMore;

  Data({
    this.podcasts,
    this.nextCursor,
    this.hasMore,
  });

  Data copyWith({
    List<PlayPodcastItem>? podcasts,
    String? nextCursor,
    bool? hasMore,
  }) =>
      Data(
        podcasts: podcasts ?? this.podcasts,
        nextCursor: nextCursor ?? this.nextCursor,
        hasMore: hasMore ?? this.hasMore,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        podcasts: json["podcasts"] == null
            ? []
            : List<PlayPodcastItem>.from(
                json["podcasts"]!.map((x) => PlayPodcastItem.fromJson(x))),
        nextCursor: json["nextCursor"],
        hasMore: json["hasMore"],
      );

  Map<String, dynamic> toJson() => {
        "podcasts": podcasts == null
            ? []
            : List<dynamic>.from(podcasts!.map((x) => x.toJson())),
        "nextCursor": nextCursor,
        "hasMore": hasMore,
      };
}

class PlayPodcastItem {
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
  final bool? isBookmark;

  PlayPodcastItem({
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
    this.isBookmark,
  });

  PlayPodcastItem copyWith({
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
    bool? isBookmark,
  }) =>
      PlayPodcastItem(
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
        isBookmark: isBookmark ?? this.isBookmark,
      );

  factory PlayPodcastItem.fromJson(Map<String, dynamic> json) =>
      PlayPodcastItem(
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
        isBookmark: json["isBookmark"],
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
        "isBookmark": isBookmark,
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
            : List<num>.from(json["coordinates"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}
