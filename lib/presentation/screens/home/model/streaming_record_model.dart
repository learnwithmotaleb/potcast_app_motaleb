class StreamingRecordModel {
  final bool? success;
  final String? message;
  final Data? data;

  StreamingRecordModel({
    this.success,
    this.message,
    this.data,
  });

  factory StreamingRecordModel.fromJson(Map<String, dynamic> json) => StreamingRecordModel(
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
  final List<StreamingRecordItem>? result;

  Data({
    this.result,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    result: json["result"] == null ? [] : List<StreamingRecordItem>.from(json["result"]!.map((x) => StreamingRecordItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class StreamingRecordItem {
  final String? id;
  final Creator? creator;
  final String? name;
  final String? description;
  final String? roomId;
  final String? sessionId;
  final String? status;
  final String? recordingPresignedUrl;
  final DateTime? sessionStartedAt;
  final int? duration;
  final String? coverImage;
  final bool? isPublic;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StreamingRecordItem({
    this.id,
    this.creator,
    this.name,
    this.description,
    this.roomId,
    this.sessionId,
    this.status,
    this.recordingPresignedUrl,
    this.sessionStartedAt,
    this.duration,
    this.coverImage,
    this.isPublic,
    this.createdAt,
    this.updatedAt,
  });

  factory StreamingRecordItem.fromJson(Map<String, dynamic> json) => StreamingRecordItem(
    id: json["_id"],
    creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
    name: json["name"],
    description: json["description"],
    roomId: json["room_id"],
    sessionId: json["session_id"],
    status: json["status"],
    recordingPresignedUrl: json["recording_presigned_url"],
    sessionStartedAt: json["session_started_at"] == null ? null : DateTime.parse(json["session_started_at"]),
    duration: json["duration"],
    coverImage: json["coverImage"],
    isPublic: json["isPublic"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "creator": creator?.toJson(),
    "name": name,
    "description": description,
    "room_id": roomId,
    "session_id": sessionId,
    "status": status,
    "recording_presigned_url": recordingPresignedUrl,
    "session_started_at": sessionStartedAt?.toIso8601String(),
    "duration": duration,
    "coverImage": coverImage,
    "isPublic": isPublic,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class Creator {
  final String? name;
  final String? profileImage;

  Creator({
    this.name,
    this.profileImage,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
    name: json["name"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "profile_image": profileImage,
  };
}
