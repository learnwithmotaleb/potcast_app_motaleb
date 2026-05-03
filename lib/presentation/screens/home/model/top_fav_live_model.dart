class TopFavLiveModel {
  final bool success;
  final String message;
  final Data? data;

  TopFavLiveModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory TopFavLiveModel.fromJson(Map<String, dynamic> json) {
    return TopFavLiveModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null ? Data.fromJson(json["data"]) : null,
    );
  }
}

class Data {
  final Location? location;
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
  final String? latestPodcastId;

  Data({
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
    this.latestPodcastId,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      location: json["location"] != null ? Location.fromJson(json["location"]) : null,
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
      latestPodcastId: json["latestPodcastId"],
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json["type"] ?? "",
      coordinates: json["coordinates"] != null
          ? List<double>.from(
              (json["coordinates"] as List).map((x) => (x ?? 0).toDouble()),
            )
          : [],
    );
  }
}
