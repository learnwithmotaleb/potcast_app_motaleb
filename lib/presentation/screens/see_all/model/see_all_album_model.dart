class SeeAllAlbumModel {
  final bool? success;
  final String? message;
  final Data? data;

  SeeAllAlbumModel({
    this.success,
    this.message,
    this.data,
  });

  SeeAllAlbumModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      SeeAllAlbumModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory SeeAllAlbumModel.fromJson(Map<String, dynamic> json) => SeeAllAlbumModel(
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
  final List<SeeAllAlbumItem>? result;

  Data({
    this.result,
  });

  Data copyWith({
    List<SeeAllAlbumItem>? result,
  }) =>
      Data(
        result: result ?? this.result,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    result: json["result"] == null ? [] : List<SeeAllAlbumItem>.from(json["result"]!.map((x) => SeeAllAlbumItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class SeeAllAlbumItem {
  final String? id;
  final String? name;
  final String? description;
  final List<String>? tags;
  final String? coverImage;
  final List<String>? podcasts;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;

  SeeAllAlbumItem({
    this.id,
    this.name,
    this.description,
    this.tags,
    this.coverImage,
    this.podcasts,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  SeeAllAlbumItem copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? tags,
    String? coverImage,
    List<String>? podcasts,
    DateTime? createdAt,
    DateTime? updatedAt,
    num? v,
  }) =>
      SeeAllAlbumItem(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        coverImage: coverImage ?? this.coverImage,
        podcasts: podcasts ?? this.podcasts,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory SeeAllAlbumItem.fromJson(Map<String, dynamic> json) => SeeAllAlbumItem(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
    coverImage: json["cover_image"],
    podcasts: json["podcasts"] == null ? [] : List<String>.from(json["podcasts"]!.map((x) => x)),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "cover_image": coverImage,
    "podcasts": podcasts == null ? [] : List<dynamic>.from(podcasts!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
