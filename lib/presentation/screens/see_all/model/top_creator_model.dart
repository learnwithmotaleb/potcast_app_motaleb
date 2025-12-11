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
  });

  factory TopCreatorItem.fromJson(Map<String, dynamic> json) => TopCreatorItem(
    name: json["name"],
    email: json["email"],
    profileImage: json["profile_image"],
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    profileCover: json["profile_cover"],
    donationLink: json["donationLink"],
    isLive: json["isLive"],
    totalViews: json["totalViews"],
    latestPodcast: json["latestPodcast"] == null ? null : LatestPodcast.fromJson(json["latestPodcast"]),
    creatorId: json["creatorId"],
    liveSession: json["liveSession"] == null ? null : LiveSession.fromJson(json["liveSession"]),
  );

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
  };
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
  LiveSession();

  factory LiveSession.fromJson(Map<String, dynamic> json) => LiveSession(
  );

  Map<String, dynamic> toJson() => {
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
