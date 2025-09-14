class HomeModel {
  final bool? success;
  final String? message;
  final Data? data;

  HomeModel({
    this.success,
    this.message,
    this.data,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
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
  final List<HomeCategoryElement>? categories;
  final List<HomeNewestPodcast>? newestPodcasts;
  final List<HomeNewestPodcast>? popularPodcasts;
  final List<HomeNewestPodcast>? reels;
  final List<HomeAlbumItem>? albums;
  final List<TopCreator>? topCreators;

  Data({
    this.categories,
    this.newestPodcasts,
    this.popularPodcasts,
    this.reels,
    this.albums,
    this.topCreators,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    categories: json["categories"] == null ? [] : List<HomeCategoryElement>.from(json["categories"]!.map((x) => HomeCategoryElement.fromJson(x))),
    newestPodcasts: json["newestPodcasts"] == null ? [] : List<HomeNewestPodcast>.from(json["newestPodcasts"]!.map((x) => HomeNewestPodcast.fromJson(x))),
    popularPodcasts: json["popularPodcasts"] == null ? [] : List<HomeNewestPodcast>.from(json["popularPodcasts"]!.map((x) => HomeNewestPodcast.fromJson(x))),
    reels: json["reels"] == null ? [] : List<HomeNewestPodcast>.from(json["reels"]!.map((x) => HomeNewestPodcast.fromJson(x))),
    albums: json["albums"] == null ? [] : List<HomeAlbumItem>.from(json["albums"]!.map((x) => HomeAlbumItem.fromJson(x))),
    topCreators: json["topCreators"] == null ? [] : List<TopCreator>.from(json["topCreators"]!.map((x) => TopCreator.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "newestPodcasts": newestPodcasts == null ? [] : List<dynamic>.from(newestPodcasts!.map((x) => x.toJson())),
    "popularPodcasts": popularPodcasts == null ? [] : List<dynamic>.from(popularPodcasts!.map((x) => x.toJson())),
    "reels": reels == null ? [] : List<dynamic>.from(reels!.map((x) => x.toJson())),
    "albums": albums == null ? [] : List<dynamic>.from(albums!.map((x) => x.toJson())),
    "topCreators": topCreators == null ? [] : List<dynamic>.from(topCreators!.map((x) => x.toJson())),
  };
}

class HomeAlbumItem {
  final String? id;
  final String? name;
  final String? description;
  final List<String>? tags;
  final String? coverImage;
  final List<String>? podcasts;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  HomeAlbumItem({
    this.id,
    this.name,
    this.description,
    this.tags,
    this.coverImage,
    this.podcasts,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory HomeAlbumItem.fromJson(Map<String, dynamic> json) => HomeAlbumItem(
    id: json["_id"],
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

class HomeCategoryElement {
  final String? id;
  final String? name;
  final String? categoryImage;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  HomeCategoryElement({
    this.id,
    this.name,
    this.categoryImage,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory HomeCategoryElement.fromJson(Map<String, dynamic> json) => HomeCategoryElement(
    id: json["_id"],
    name: json["name"],
    categoryImage: json["category_image"],
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "category_image": categoryImage,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class HomeNewestPodcast {
  final Location? location;
  final String? id;
  final Creator? creator;
  final SubCategoryClass? category;
  final SubCategoryClass? subCategory;
  final String? coverImage;
  final String? podcastUrl;
  final String? title;
  final String? description;
  final String? address;
  final List<String>? tags;
  final int? totalView;
  final int? duration;
  final List<Liker>? likers;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  HomeNewestPodcast({
    this.location,
    this.id,
    this.creator,
    this.category,
    this.subCategory,
    this.coverImage,
    this.podcastUrl,
    this.title,
    this.description,
    this.address,
    this.tags,
    this.totalView,
    this.duration,
    this.likers,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory HomeNewestPodcast.fromJson(Map<String, dynamic> json) => HomeNewestPodcast(
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    id: json["_id"],
    creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
    category: json["category"] == null ? null : SubCategoryClass.fromJson(json["category"]),
    subCategory: json["subCategory"] == null ? null : SubCategoryClass.fromJson(json["subCategory"]),
    coverImage: json["coverImage"],
    podcastUrl: json["podcast_url"],
    title: json["title"],
    description: json["description"],
    address: json["address"],
    tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
    totalView: json["totalView"],
    duration: json["duration"],
    likers: json["likers"] == null ? [] : List<Liker>.from(json["likers"]!.map((x) => Liker.fromJson(x))),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "location": location?.toJson(),
    "_id": id,
    "creator": creator?.toJson(),
    "category": category?.toJson(),
    "subCategory": subCategory?.toJson(),
    "coverImage": coverImage,
    "podcast_url": podcastUrl,
    "title": title,
    "description": description,
    "address": address,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "totalView": totalView,
    "duration": duration,
    "likers": likers == null ? [] : List<dynamic>.from(likers!.map((x) => x.toJson())),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class SubCategoryClass {
  final String? id;
  final String? name;

  SubCategoryClass({
    this.id,
    this.name,
  });

  factory SubCategoryClass.fromJson(Map<String, dynamic> json) => SubCategoryClass(
    id: json["_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
  };
}

class Creator {
  final String? id;
  final String? name;
  final String? profileImage;

  Creator({
    this.id,
    this.name,
    this.profileImage,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
    id: json["_id"],
    name: json["name"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "profile_image": profileImage,
  };
}

class Liker {
  final String? user;
  final String? userType;
  final String? id;

  Liker({
    this.user,
    this.userType,
    this.id,
  });

  factory Liker.fromJson(Map<String, dynamic> json) => Liker(
    user: json["user"],
    userType: json["userType"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "user": user,
    "userType": userType,
    "_id": id,
  };
}

class Location {
  final String? type;
  final List<double>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"],
    coordinates: json["coordinates"] == null ? [] : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
  };
}

class TopCreator {
  final String? name;
  final String? email;
  final String? profileImage;
  final Location? location;
  final String? profileCover;
  final String? donationLink;
  final LiveSession? liveSession;
  final bool? isLive;
  final StreamRoom? streamRoom;
  final int? totalViews;
  final LatestPodcast? latestPodcast;
  final String? creatorId;

  TopCreator({
    this.name,
    this.email,
    this.profileImage,
    this.location,
    this.profileCover,
    this.donationLink,
    this.liveSession,
    this.isLive,
    this.streamRoom,
    this.totalViews,
    this.latestPodcast,
    this.creatorId,
  });

  factory TopCreator.fromJson(Map<String, dynamic> json) => TopCreator(
    name: json["name"],
    email: json["email"],
    profileImage: json["profile_image"],
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    profileCover: json["profile_cover"],
    donationLink: json["donationLink"],
    liveSession: json["liveSession"] == null ? null : LiveSession.fromJson(json["liveSession"]),
    isLive: json["isLive"],
    streamRoom: json["streamRoom"] == null ? null : StreamRoom.fromJson(json["streamRoom"]),
    totalViews: json["totalViews"],
    latestPodcast: json["latestPodcast"] == null ? null : LatestPodcast.fromJson(json["latestPodcast"]),
    creatorId: json["creatorId"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "profile_image": profileImage,
    "location": location?.toJson(),
    "profile_cover": profileCover,
    "donationLink": donationLink,
    "liveSession": liveSession?.toJson(),
    "isLive": isLive,
    "streamRoom": streamRoom?.toJson(),
    "totalViews": totalViews,
    "latestPodcast": latestPodcast?.toJson(),
    "creatorId": creatorId,
  };

  bool get isLiveRunning {
    if (isLive != true) return false;
    if (liveSession == null) return false;
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

class LatestPodcast {
  final String? title;
  final String? description;
  final String? podcastUrl;
  final String? coverImage;

  LatestPodcast({
    this.title,
    this.description,
    this.podcastUrl,
    this.coverImage,
  });

  factory LatestPodcast.fromJson(Map<String, dynamic> json) => LatestPodcast(
    title: json["title"],
    description: json["description"],
    podcastUrl: json["podcast_url"],
    coverImage: json["coverImage"],
  );

  Map<String, dynamic> toJson() => {
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

  factory LiveSession.fromJson(Map<String, dynamic> json) => LiveSession(
    sessionId: json["session_id"],
    name: json["name"],
    description: json["description"],
    coverImage: json["coverImage"],
    sessionStartedAt: json["session_started_at"] == null ? null : DateTime.parse(json["session_started_at"]),
    duration: json["duration"],
  );

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

  StreamRoom({
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

  factory StreamRoom.fromJson(Map<String, dynamic> json) => StreamRoom(
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
