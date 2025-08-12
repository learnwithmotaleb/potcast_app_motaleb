class CommentsModel {
  final bool? success;
  final String? message;
  final Data? data;

  CommentsModel({
    this.success,
    this.message,
    this.data,
  });

  factory CommentsModel.fromJson(Map<String, dynamic> json) => CommentsModel(
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
  final List<Comment>? comments;
  final int? currentPage;
  final int? limit;

  Data({
    this.comments,
    this.currentPage,
    this.limit,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        comments: json["comments"] == null
            ? []
            : List<Comment>.from(
                json["comments"]!.map((x) => Comment.fromJson(x))),
        currentPage: json["currentPage"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "comments": comments == null
            ? []
            : List<dynamic>.from(comments!.map((x) => x.toJson())),
        "currentPage": currentPage,
        "limit": limit,
      };
}

class Comment {
  final String? id;
  final User? user;
  final String? text;

  Comment({
    this.id,
    this.user,
    this.text,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["_id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user?.toJson(),
        "text": text,
      };
}

class User {
  final String? id;
  final String? name;
  final String? avatar;

  User({
    this.id,
    this.name,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "avatar": avatar,
      };
}
