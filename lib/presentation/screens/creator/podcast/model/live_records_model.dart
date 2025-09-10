class LiveRecordsModel {
  final bool? success;
  final String? message;
  final Data? data;

  LiveRecordsModel({
    this.success,
    this.message,
    this.data,
  });

  LiveRecordsModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      LiveRecordsModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory LiveRecordsModel.fromJson(Map<String, dynamic> json) => LiveRecordsModel(
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
  final List<LiveRecordItem>? result;

  Data({
    this.meta,
    this.result,
  });

  Data copyWith({
    Meta? meta,
    List<LiveRecordItem>? result,
  }) =>
      Data(
        meta: meta ?? this.meta,
        result: result ?? this.result,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    result: json["result"] == null ? [] : List<LiveRecordItem>.from(json["result"]!.map((x) => LiveRecordItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class Meta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  Meta({
    this.page,
    this.limit,
    this.total,
    this.totalPage,
  });

  Meta copyWith({
    int? page,
    int? limit,
    int? total,
    int? totalPage,
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

class LiveRecordItem {
  final String? id;
  final Creator? creator;
  final String? name;
  final String? description;
  final String? roomId;
  final String? sessionId;
  final String? status;
  final bool? isPublic;
  final String? recordingPresignedUrl;
  final DateTime? sessionStartedAt;
  final int? duration;
  final String? coverImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LiveRecordItem({
    this.id,
    this.creator,
    this.name,
    this.description,
    this.roomId,
    this.sessionId,
    this.status,
    this.isPublic,
    this.recordingPresignedUrl,
    this.sessionStartedAt,
    this.duration,
    this.coverImage,
    this.createdAt,
    this.updatedAt,
  });

  LiveRecordItem copyWith({
    String? id,
    Creator? creator,
    String? name,
    String? description,
    String? roomId,
    String? sessionId,
    String? status,
    bool? isPublic,
    String? recordingPresignedUrl,
    DateTime? sessionStartedAt,
    int? duration,
    String? coverImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      LiveRecordItem(
        id: id ?? this.id,
        creator: creator ?? this.creator,
        name: name ?? this.name,
        description: description ?? this.description,
        roomId: roomId ?? this.roomId,
        sessionId: sessionId ?? this.sessionId,
        status: status ?? this.status,
        isPublic: isPublic ?? this.isPublic,
        recordingPresignedUrl: recordingPresignedUrl ?? this.recordingPresignedUrl,
        sessionStartedAt: sessionStartedAt ?? this.sessionStartedAt,
        duration: duration ?? this.duration,
        coverImage: coverImage ?? this.coverImage,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory LiveRecordItem.fromJson(Map<String, dynamic> json) => LiveRecordItem(
    id: json["_id"],
    creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
    name: json["name"],
    description: json["description"],
    roomId: json["room_id"],
    sessionId: json["session_id"],
    status: json["status"],
    isPublic: json["isPublic"],
    recordingPresignedUrl: json["recording_presigned_url"],
    sessionStartedAt: json["session_started_at"] == null ? null : DateTime.parse(json["session_started_at"]),
    duration: json["duration"],
    coverImage: json["coverImage"],
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
    "isPublic": isPublic,
    "recording_presigned_url": recordingPresignedUrl,
    "session_started_at": sessionStartedAt?.toIso8601String(),
    "duration": duration,
    "coverImage": coverImage,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class Creator {
  final List<String>? name;
  final List<String>? profileImage;

  Creator({
    this.name,
    this.profileImage,
  });

  Creator copyWith({
    List<String>? name,
    List<String>? profileImage,
  }) =>
      Creator(
        name: name ?? this.name,
        profileImage: profileImage ?? this.profileImage,
      );

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
    name: json["name"] == null ? [] : List<String>.from(json["name"]!.map((x) => x)),
    profileImage: json["profile_image"] == null ? [] : List<String>.from(json["profile_image"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? [] : List<dynamic>.from(name!.map((x) => x)),
    "profile_image": profileImage == null ? [] : List<dynamic>.from(profileImage!.map((x) => x)),
  };
}
