class CommentModel {
  final bool? success;
  final String? message;
  final Data? data;

  CommentModel({
    this.success,
    this.message,
    this.data,
  });

  CommentModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      CommentModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
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
  final List<CommentItem>? result;

  Data({
    this.result,
  });

  Data copyWith({
    List<CommentItem>? result,
  }) =>
      Data(
        result: result ?? this.result,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    result: json["result"] == null ? [] : List<CommentItem>.from(json["result"]!.map((x) => CommentItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class CommentItem {
  final String? id;
  final String? text;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isMyComment;
  final num? totalLike;
  final num? totalReplies;
  final String? commentorName;
  final String? commentorProfileImage;

  CommentItem({
    this.id,
    this.text,
    this.createdAt,
    this.updatedAt,
    this.isMyComment,
    this.totalLike,
    this.totalReplies,
    this.commentorName,
    this.commentorProfileImage,
  });

  CommentItem copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isMyComment,
    num? totalLike,
    num? totalReplies,
    String? commentorName,
    String? commentorProfileImage,
  }) =>
      CommentItem(
        id: id ?? this.id,
        text: text ?? this.text,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isMyComment: isMyComment ?? this.isMyComment,
        totalLike: totalLike ?? this.totalLike,
        totalReplies: totalReplies ?? this.totalReplies,
        commentorName: commentorName ?? this.commentorName,
        commentorProfileImage: commentorProfileImage ?? this.commentorProfileImage,
      );

  factory CommentItem.fromJson(Map<String, dynamic> json) => CommentItem(
    id: json["_id"],
    text: json["text"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    isMyComment: json["isMyComment"],
    totalLike: json["totalLike"],
    totalReplies: json["totalReplies"],
    commentorName: json["commentorName"],
    commentorProfileImage: json["commentorProfileImage"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "text": text,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "isMyComment": isMyComment,
    "totalLike": totalLike,
    "totalReplies": totalReplies,
    "commentorName": commentorName,
    "commentorProfileImage": commentorProfileImage,
  };
}
