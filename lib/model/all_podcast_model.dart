class AllPodcastModel {
  final bool? success;
  final String? message;
  final Data? data;

  AllPodcastModel({
    this.success,
    this.message,
    this.data,
  });

  AllPodcastModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      AllPodcastModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory AllPodcastModel.fromJson(Map<String, dynamic> json) =>
      AllPodcastModel(
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
  final List<AllPodcastItem>? result;

  Data({
    this.result,
  });

  Data copyWith({
    List<AllPodcastItem>? result,
  }) =>
      Data(
        result: result ?? this.result,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] == null
            ? []
            : List<AllPodcastItem>.from(
                json["result"]!.map((x) => AllPodcastItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class AllPodcastItem {
  final Location? location;
  final String? id;
  final Creator? creator;
  final Category? category;
  final Category? subCategory;
  final String? coverImage;
  final String? podcastUrl;
  final String? title;
  final String? description;
  final String? address;
  final List<String?>? tags;
  final num? totalView;
  final num? duration;
  final List<dynamic>? liker;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;

  AllPodcastItem({
    this.location,
    this.id,
    this.creator,
    this.category,
    this.subCategory,
    this.coverImage,
    this.podcastUrl,
    this.title,
    this.description,
    this.address,
    this.tags,
    this.totalView,
    this.duration,
    this.liker,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  AllPodcastItem copyWith({
    Location? location,
    String? id,
    Creator? creator,
    Category? category,
    Category? subCategory,
    String? coverImage,
    String? podcastUrl,
    String? title,
    String? description,
    String? address,
    List<String?>? tags,
    num? totalView,
    num? duration,
    List<dynamic>? liker,
    DateTime? createdAt,
    DateTime? updatedAt,
    num? v,
  }) =>
      AllPodcastItem(
        location: location ?? this.location,
        id: id ?? this.id,
        creator: creator ?? this.creator,
        category: category ?? this.category,
        subCategory: subCategory ?? this.subCategory,
        coverImage: coverImage ?? this.coverImage,
        podcastUrl: podcastUrl ?? this.podcastUrl,
        title: title ?? this.title,
        description: description ?? this.description,
        address: address ?? this.address,
        tags: tags ?? this.tags,
        totalView: totalView ?? this.totalView,
        duration: duration ?? this.duration,
        liker: liker ?? this.liker,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory AllPodcastItem.fromJson(Map<String, dynamic> json) => AllPodcastItem(
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        id: json["_id"],
        creator:
            json["creator"] == null ? null : Creator.fromJson(json["creator"]),
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        subCategory: json["subCategory"] == null
            ? null
            : Category.fromJson(json["subCategory"]),
        coverImage: json["coverImage"],
        podcastUrl: json["podcast_url"],
        title: json["title"],
        description: json["description"],
        address: json["address"],
        tags: json["tags"] == null
            ? []
            : List<String?>.from(json["tags"]!.map((x) => x)),
        totalView: json["totalView"],
        duration: json["duration"],
        liker: json["liker"] == null
            ? []
            : List<dynamic>.from(json["liker"]!.map((x) => x)),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
        "_id": id,
        "creator": creator?.toJson(),
        "category": category?.toJson(),
        "subCategory": subCategory?.toJson(),
        "coverImage": coverImage,
        "podcast_url": podcastUrl,
        "title": title,
        "description": description,
        "address": address,
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "totalView": totalView,
        "duration": duration,
        "liker": liker == null ? [] : List<dynamic>.from(liker!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
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

class Creator {
  final String? id;
  final String? name;
  final String? profileImage;

  Creator({
    this.id,
    this.name,
    this.profileImage,
  });

  Creator copyWith({
    String? id,
    String? name,
    String? profileImage,
  }) =>
      Creator(
        id: id ?? this.id,
        name: name ?? this.name,
        profileImage: profileImage ?? this.profileImage,
      );

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        id: json["_id"],
        name: json["name"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "profile_image": profileImage,
      };
}

class Location {
  final String? type;
  final List<num?>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  Location copyWith({
    String? type,
    List<num?>? coordinates,
  }) =>
      Location(
        type: type ?? this.type,
        coordinates: coordinates ?? this.coordinates,
      );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? []
            : List<num?>.from(json["coordinates"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}
