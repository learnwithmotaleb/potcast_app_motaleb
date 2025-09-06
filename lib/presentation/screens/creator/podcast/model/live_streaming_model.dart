class LiveStreamingModel {
  final bool? success;
  final String? message;
  final Data? data;

  LiveStreamingModel({
    this.success,
    this.message,
    this.data,
  });

  factory LiveStreamingModel.fromJson(Map<String, dynamic> json) => LiveStreamingModel(
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
  final String? host;
  final String? name;
  final String? description;
  final String? templateId;
  final String? roomId;
  final String? status;
  final dynamic startTime;
  final dynamic endTime;
  final List<RoomCode>? roomCodes;
  final List<dynamic>? recordings;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Data({
    this.id,
    this.host,
    this.name,
    this.description,
    this.templateId,
    this.roomId,
    this.status,
    this.startTime,
    this.endTime,
    this.roomCodes,
    this.recordings,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    host: json["host"],
    name: json["name"],
    description: json["description"],
    templateId: json["template_id"],
    roomId: json["room_id"],
    status: json["status"],
    startTime: json["startTime"],
    endTime: json["endTime"],
    roomCodes: json["roomCodes"] == null ? [] : List<RoomCode>.from(json["roomCodes"]!.map((x) => RoomCode.fromJson(x))),
    recordings: json["recordings"] == null ? [] : List<dynamic>.from(json["recordings"]!.map((x) => x)),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "host": host,
    "name": name,
    "description": description,
    "template_id": templateId,
    "room_id": roomId,
    "status": status,
    "startTime": startTime,
    "endTime": endTime,
    "roomCodes": roomCodes == null ? [] : List<dynamic>.from(roomCodes!.map((x) => x.toJson())),
    "recordings": recordings == null ? [] : List<dynamic>.from(recordings!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class RoomCode {
  final String? roomCodeId;
  final String? code;
  final String? roomId;
  final String? role;
  final bool? enabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? id;

  RoomCode({
    this.roomCodeId,
    this.code,
    this.roomId,
    this.role,
    this.enabled,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  factory RoomCode.fromJson(Map<String, dynamic> json) => RoomCode(
    roomCodeId: json["id"],
    code: json["code"],
    roomId: json["room_id"],
    role: json["role"],
    enabled: json["enabled"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": roomCodeId,
    "code": code,
    "room_id": roomId,
    "role": role,
    "enabled": enabled,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "_id": id,
  };
}
