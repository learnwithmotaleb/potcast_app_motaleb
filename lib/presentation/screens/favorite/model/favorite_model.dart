class FavoriteModel {
  final bool? success;
  final String? message;
  final Data? data;

  FavoriteModel({
    this.success,
    this.message,
    this.data,
  });

  FavoriteModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      FavoriteModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
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
  final List<FavoriteItem>? result;

  Data({
    this.meta,
    this.result,
  });

  Data copyWith({
    Meta? meta,
    List<FavoriteItem>? result,
  }) =>
      Data(
        meta: meta ?? this.meta,
        result: result ?? this.result,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        result: json["result"] == null
            ? []
            : List<FavoriteItem>.from(
                json["result"]!.map((x) => FavoriteItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
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

  Meta copyWith({
    num? page,
    num? limit,
    num? total,
    num? totalPage,
  }) =>
      Meta(
        page: page ?? this.page,
        limit: limit ?? this.limit,
        total: total ?? this.total,
        totalPage: totalPage ?? this.totalPage,
      );

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

class FavoriteItem {
  final String? id;
  final Podcast? podcast;
  final String? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;

  FavoriteItem({
    this.id,
    this.podcast,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  FavoriteItem copyWith({
    String? id,
    Podcast? podcast,
    String? user,
    DateTime? createdAt,
    DateTime? updatedAt,
    num? v,
  }) =>
      FavoriteItem(
        id: id ?? this.id,
        podcast: podcast ?? this.podcast,
        user: user ?? this.user,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory FavoriteItem.fromJson(Map<String, dynamic> json) => FavoriteItem(
        id: json["_id"],
        podcast:
            json["podcast"] == null ? null : Podcast.fromJson(json["podcast"]),
        user: json["user"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "podcast": podcast?.toJson(),
        "user": user,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class Podcast {
  final String? id;
  final Creator? creator;
  final Category? category;
  final Category? subCategory;
  final String? title;
  final String? coverImage;
  final num? totalView;
  final num? duration;
  final DateTime? createdAt;

  Podcast({
    this.id,
    this.creator,
    this.category,
    this.subCategory,
    this.title,
    this.coverImage,
    this.totalView,
    this.duration,
    this.createdAt,
  });

  Podcast copyWith({
    String? id,
    Creator? creator,
    Category? category,
    Category? subCategory,
    String? title,
    String? coverImage,
    num? totalView,
    num? duration,
    DateTime? createdAt,
  }) =>
      Podcast(
        id: id ?? this.id,
        creator: creator ?? this.creator,
        category: category ?? this.category,
        subCategory: subCategory ?? this.subCategory,
        title: title ?? this.title,
        coverImage: coverImage ?? this.coverImage,
        totalView: totalView ?? this.totalView,
        duration: duration ?? this.duration,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Podcast.fromJson(Map<String, dynamic> json) => Podcast(
        id: json["_id"],
        creator:
            json["creator"] == null ? null : Creator.fromJson(json["creator"]),
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        subCategory: json["subCategory"] == null
            ? null
            : Category.fromJson(json["subCategory"]),
        title: json["title"],
        coverImage: json["coverImage"],
        totalView: json["totalView"],
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
        "title": title,
        "coverImage": coverImage,
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
