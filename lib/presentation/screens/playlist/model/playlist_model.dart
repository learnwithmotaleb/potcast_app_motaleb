class MyPlayListModel {
  final bool? success;
  final String? message;
  final Data? data;

  MyPlayListModel({
    this.success,
    this.message,
    this.data,
  });

  MyPlayListModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      MyPlayListModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory MyPlayListModel.fromJson(Map<String, dynamic> json) => MyPlayListModel(
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
  final List<PlaylistItem>? result;

  Data({
    this.result,
  });

  Data copyWith({
    List<PlaylistItem>? result,
  }) =>
      Data(
        result: result ?? this.result,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    result: json["result"] == null ? [] : List<PlaylistItem>.from(json["result"]!.map((x) => PlaylistItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class PlaylistItem {
  final String? id;
  final String? user;
  final String? userType;
  final String? name;
  final String? description;
  final List<String>? tags;
  final String? coverImage;
  final List<String>? podcasts;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  PlaylistItem({
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

  PlaylistItem copyWith({
    String? id,
    String? user,
    String? userType,
    String? name,
    String? description,
    List<String>? tags,
    String? coverImage,
    List<String>? podcasts,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      PlaylistItem(
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

  factory PlaylistItem.fromJson(Map<String, dynamic> json) => PlaylistItem(
    id: json["_id"],
    user: json["user"],
    userType: json["userType"],
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
    "user": user,
    "userType": userType,
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
