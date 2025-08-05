class HistoryModel {
  final bool? success;
  final String? message;
  final Data? data;

  HistoryModel({
    this.success,
    this.message,
    this.data,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
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
  final Meta? meta;
  final List<HistoryItem>? result;

  Data({
    this.meta,
    this.result,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    result: json["result"] == null ? [] : List<HistoryItem>.from(json["result"]!.map((x) => HistoryItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class Meta {
  final num? page;
  final num? limit;
  final num? total;
  final num? totalPage;

  Meta({
    this.page,
    this.limit,
    this.total,
    this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    totalPage: json["totalPage"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
    "totalPage": totalPage,
  };
}

class HistoryItem {
  final String? id;
  final String? user;
  final Podcast? podcast;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;

  HistoryItem({
    this.id,
    this.user,
    this.podcast,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
    id: json["_id"],
    user: json["user"],
    podcast: json["podcast"] == null ? null : Podcast.fromJson(json["podcast"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "podcast": podcast?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class Podcast {
  final Location? location;
  final String? id;
  final Creator? creator;
  final Category? category;
  final Category? subCategory;
  final String? coverImage;
  final String? audioUrl;
  final String? title;
  final String? description;
  final String? address;
  final List<String>? tags;
  final num? totalView;
  final num? duration;
  final DateTime? createdAt;

  Podcast({
    this.location,
    this.id,
    this.creator,
    this.category,
    this.subCategory,
    this.coverImage,
    this.audioUrl,
    this.title,
    this.description,
    this.address,
    this.tags,
    this.totalView,
    this.duration,
    this.createdAt,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) => Podcast(
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    id: json["_id"],
    creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
    subCategory: json["subCategory"] == null ? null : Category.fromJson(json["subCategory"]),
    coverImage: json["coverImage"],
    audioUrl: json["audio_url"],
    title: json["title"],
    description: json["description"],
    address: json["address"],
    tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
    totalView: json["totalView"],
    duration: json["duration"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "location": location?.toJson(),
    "_id": id,
    "creator": creator?.toJson(),
    "category": category?.toJson(),
    "subCategory": subCategory?.toJson(),
    "coverImage": coverImage,
    "audio_url": audioUrl,
    "title": title,
    "description": description,
    "address": address,
    "tags": tags == null ? [] : List<String>.from(tags!.map((x) => x)),
    "totalView": totalView,
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
  final List<num>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"],
    coordinates: json["coordinates"] == null ? [] : List<num>.from(json["coordinates"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
  };
}
