class PlayListSongsModel {
  final bool? success;
  final String? message;
  final Data? data;

  PlayListSongsModel({
    this.success,
    this.message,
    this.data,
  });

  PlayListSongsModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      PlayListSongsModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory PlayListSongsModel.fromJson(Map<String, dynamic> json) => PlayListSongsModel(
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
  final String? id;
  final dynamic user;
  final String? userType;
  final String? name;
  final String? description;
  final List<String>? tags;
  final String? coverImage;
  final List<PlayListPodcastItem>? podcasts;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;

  Data({
    this.id,
    this.user,
    this.userType,
    this.name,
    this.description,
    this.tags,
    this.coverImage,
    this.podcasts,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Data copyWith({
    String? id,
    dynamic user,
    String? userType,
    String? name,
    String? description,
    List<String>? tags,
    String? coverImage,
    List<PlayListPodcastItem>? podcasts,
    DateTime? createdAt,
    DateTime? updatedAt,
    num? v,
  }) =>
      Data(
        id: id ?? this.id,
        user: user ?? this.user,
        userType: userType ?? this.userType,
        name: name ?? this.name,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        coverImage: coverImage ?? this.coverImage,
        podcasts: podcasts ?? this.podcasts,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    user: json["user"],
    userType: json["userType"],
    name: json["name"],
    description: json["description"],
    tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
    coverImage: json["cover_image"],
    podcasts: json["podcasts"] == null ? [] : List<PlayListPodcastItem>.from(json["podcasts"]!.map((x) => PlayListPodcastItem.fromJson(x))),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "userType": userType,
    "name": name,
    "description": description,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "cover_image": coverImage,
    "podcasts": podcasts == null ? [] : List<dynamic>.from(podcasts!.map((x) => x.toJson())),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class PlayListPodcastItem {
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

  PlayListPodcastItem({
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

  PlayListPodcastItem copyWith({
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
      PlayListPodcastItem(
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

  factory PlayListPodcastItem.fromJson(Map<String, dynamic> json) => PlayListPodcastItem(
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    id: json["_id"],
    creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
    subCategory: json["subCategory"] == null ? null : Category.fromJson(json["subCategory"]),
    coverImage: json["coverImage"],
    podcastUrl: json["podcast_url"],
    title: json["title"],
    description: json["description"],
    address: json["address"],
    tags: json["tags"] == null ? [] : List<String?>.from(json["tags"]!.map((x) => x)),
    totalView: json["totalView"],
    duration: json["duration"],
    liker: json["liker"] == null ? [] : List<dynamic>.from(json["liker"]!.map((x) => x)),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
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
    coordinates: json["coordinates"] == null ? [] : List<num?>.from(json["coordinates"]?.map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
  };
}
