import 'package:podcast/presentation/screens/home/model/home_model.dart'
    show LiveSession, StreamRoom;

class TopFavLiveModel {
  final bool success;
  final String message;
  final StationData? data;

  TopFavLiveModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory TopFavLiveModel.fromJson(Map<String, dynamic> json) {
    return TopFavLiveModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null ? StationData.fromJson(json["data"]) : null,
    );
  }
}

class StationData {
  final StationLocation? location;
  final String id;
  final String name;
  final String description;
  final String address;
  final bool isLive;
  final String donationUrl;
  final String profileImage;
  final String coverImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int version;
  final LiveSession? liveSession;
  final StreamRoom? streamRoom;
  final int totalViews;
  final String? latestPodcastId;

  StationData({
    this.location,
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.isLive,
    required this.donationUrl,
    required this.profileImage,
    required this.coverImage,
    this.createdAt,
    this.updatedAt,
    required this.version,
    this.liveSession,
    this.streamRoom,
    this.totalViews = 0,
    this.latestPodcastId,
  });

  factory StationData.fromJson(Map<String, dynamic> json) {
    return StationData(
      location: json["location"] != null
          ? StationLocation.fromJson(json["location"])
          : null,
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      address: json["address"] ?? "",
      isLive: json["isLive"] ?? false,
      donationUrl: json["donationUrl"] ?? "",
      profileImage: json["profile_image"] ?? "",
      coverImage: json["cover_image"] ?? "",
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"])
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.tryParse(json["updatedAt"])
          : null,
      version: json["__v"] ?? 0,
      liveSession: (json["liveSession"] == null ||
              (json["liveSession"] is Map &&
                  (json["liveSession"] as Map).isEmpty))
          ? null
          : LiveSession.fromJson(json["liveSession"]),
      streamRoom: (json["streamRoom"] == null ||
              (json["streamRoom"] is Map &&
                  (json["streamRoom"] as Map).isEmpty))
          ? null
          : StreamRoom.fromJson(json["streamRoom"]),
      totalViews: json["totalViews"] ?? 0,
      latestPodcastId: json["latestPodcastId"],
    );
  }

  /// Check if the station host is actually live and joinable
  bool get isLiveRunning {
    if (!isLive) return false;
    if (streamRoom == null) return false;

    final hasParticipantsWithCode = streamRoom?.roomCodes?.any(
          (roomCode) =>
              roomCode.role == "participants" &&
              (roomCode.code?.isNotEmpty ?? false),
        ) ??
        false;

    return hasParticipantsWithCode;
  }
}

class StationLocation {
  final String type;
  final List<double> coordinates;

  StationLocation({
    required this.type,
    required this.coordinates,
  });

  factory StationLocation.fromJson(Map<String, dynamic> json) {
    return StationLocation(
      type: json["type"] ?? "",
      coordinates: json["coordinates"] != null
          ? List<double>.from(
              (json["coordinates"] as List).map((x) => (x ?? 0).toDouble()),
            )
          : [],
    );
  }
}
