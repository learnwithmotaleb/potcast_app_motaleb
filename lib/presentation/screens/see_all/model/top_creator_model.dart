import 'package:flutter/foundation.dart';

class TopCreatorModel {
  final bool? success;
  final String? message;
  final Data? data;

  TopCreatorModel({
    this.success,
    this.message,
    this.data,
  });

  factory TopCreatorModel.fromJson(Map<String, dynamic> json) => TopCreatorModel(
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
  final List<TopCreatorItem>? result;

  Data({
    this.meta,
    this.result,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    result: json["result"] == null ? [] : List<TopCreatorItem>.from(json["result"]!.map((x) => TopCreatorItem.fromJson(x))),
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

class TopCreatorItem {
  final String? name;
  final String? email;
  final String? profileImage;
  final Location? location;
  final String? profileCover;
  final String? donationLink;
  final bool? isLive;
  final num? totalViews;
  final LatestPodcast? latestPodcast;
  final String? creatorId;
  final LiveSession? liveSession;
  final StreamRoom? streamRoom; // ✅ ADD

  TopCreatorItem({
    this.name,
    this.email,
    this.profileImage,
    this.location,
    this.profileCover,
    this.donationLink,
    this.isLive,
    this.totalViews,
    this.latestPodcast,
    this.creatorId,
    this.liveSession,
    this.streamRoom, // ✅ ADD
  });

  factory TopCreatorItem.fromJson(Map<String, dynamic> json) {
    return TopCreatorItem(
      name: json["name"],
      email: json["email"],
      profileImage: json["profile_image"],
      location: json["location"] == null ? null : Location.fromJson(json["location"]),
      profileCover: json["profile_cover"],
      donationLink: json["donationLink"],
      isLive: json["isLive"],
      totalViews: json["totalViews"],
      latestPodcast: (json["latestPodcast"] == null || (json["latestPodcast"] is Map && (json["latestPodcast"] as Map).isEmpty))
          ? null 
          : LatestPodcast.fromJson(json["latestPodcast"]),
      creatorId: json["creatorId"],
      liveSession: (json["liveSession"] == null || (json["liveSession"] is Map && (json["liveSession"] as Map).isEmpty))
          ? null 
          : LiveSession.fromJson(json["liveSession"]),
      streamRoom: (json["streamRoom"] == null || (json["streamRoom"] is Map && (json["streamRoom"] as Map).isEmpty))
          ? null 
          : StreamRoom.fromJson(json["streamRoom"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "profile_image": profileImage,
    "location": location?.toJson(),
    "profile_cover": profileCover,
    "donationLink": donationLink,
    "isLive": isLive,
    "totalViews": totalViews,
    "latestPodcast": latestPodcast?.toJson(),
    "creatorId": creatorId,
    "liveSession": liveSession?.toJson(),
    "streamRoom": streamRoom?.toJson(), // ✅ ADD
  };

  bool get isLiveRunning {
    debugPrint("🔍 [SeeAll] Checking Live Status for: $name");
    if (isLive != true) return false;
    if (streamRoom == null) return false;
    
    final hasParticipantsWithCode = streamRoom?.roomCodes?.any(
          (roomCode) =>
      roomCode.role == "participants" &&
          (roomCode.code?.isNotEmpty ?? false),
    ) ?? false;
    
    return hasParticipantsWithCode;
  }
}

class LatestPodcast {
  final String? id;
  final String? title;
  final String? description;
  final String? podcastUrl;
  final String? coverImage;

  LatestPodcast({
    this.id,
    this.title,
    this.description,
    this.podcastUrl,
    this.coverImage,
  });

  factory LatestPodcast.fromJson(Map<String, dynamic> json) => LatestPodcast(
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    podcastUrl: json["podcast_url"],
    coverImage: json["coverImage"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "podcast_url": podcastUrl,
    "coverImage": coverImage,
  };
}

class LiveSession {
  final String? sessionId;
  final String? name;
  final String? description;
  final String? coverImage;
  final DateTime? sessionStartedAt;
  final dynamic duration;

  LiveSession({
    this.sessionId,
    this.name,
    this.description,
    this.coverImage,
    this.sessionStartedAt,
    this.duration,
  });

  factory LiveSession.fromJson(Map<String, dynamic> json) {
    DateTime? startedAt;
    try {
      if (json["session_started_at"] != null) {
        startedAt = DateTime.tryParse(json["session_started_at"]);
      }
    } catch (e) {
      debugPrint("⚠️ [SeeAll] Error parsing session_started_at: $e");
    }

    return LiveSession(
      sessionId: json["session_id"],
      name: json["name"],
      description: json["description"],
      coverImage: json["coverImage"],
      sessionStartedAt: startedAt,
      duration: json["duration"],
    );
  }

  Map<String, dynamic> toJson() => {
    "session_id": sessionId,
    "name": name,
    "description": description,
    "coverImage": coverImage,
    "session_started_at": sessionStartedAt?.toIso8601String(),
    "duration": duration,
  };
}

class StreamRoom {
  final String? id;
  final String? status;
  final List<RoomCode>? roomCodes;

  StreamRoom({this.id, this.status, this.roomCodes});

  factory StreamRoom.fromJson(Map<String, dynamic> json) => StreamRoom(
    id: json["_id"],
    status: json["status"],
    roomCodes: json["roomCodes"] == null
        ? []
        : List<RoomCode>.from(json["roomCodes"]!.map((x) => RoomCode.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "status": status,
    "roomCodes": roomCodes == null ? [] : List<dynamic>.from(roomCodes!.map((x) => x.toJson())),
  };
}

class RoomCode {
  final String? id;
  final String? code;
  final String? role;
  final bool? enabled;

  RoomCode({this.id, this.code, this.role, this.enabled});

  factory RoomCode.fromJson(Map<String, dynamic> json) => RoomCode(
    id: json["id"],
    code: json["code"],
    role: json["role"],
    enabled: json["enabled"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "role": role,
    "enabled": enabled,
  };
}

class Location {
  final String? type;
  final List<dynamic>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"],
    coordinates: json["coordinates"] == null ? [] : List<dynamic>.from(json["coordinates"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
  };
}
