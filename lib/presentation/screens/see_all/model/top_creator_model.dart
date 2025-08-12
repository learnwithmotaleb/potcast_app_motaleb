class TopCreatorModel {
  final bool? success;
  final String? message;
  final Data? data;

  TopCreatorModel({
    this.success,
    this.message,
    this.data,
  });

  TopCreatorModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      TopCreatorModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

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
  final List<TopCreatorItem>? result;

  Data({
    this.result,
  });

  Data copyWith({
    List<TopCreatorItem>? result,
  }) =>
      Data(
        result: result ?? this.result,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    result: json["result"] == null ? [] : List<TopCreatorItem>.from(json["result"]!.map((x) => TopCreatorItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class TopCreatorItem {
  final num? totalViews;
  final String? creatorId;
  final String? name;
  final String? email;
  final String? profileImage;
  final String? profileCover;
  final Location? location;

  TopCreatorItem({
    this.totalViews,
    this.creatorId,
    this.name,
    this.email,
    this.profileImage,
    this.profileCover,
    this.location,
  });

  TopCreatorItem copyWith({
    num? totalViews,
    String? creatorId,
    String? name,
    String? email,
    String? profileImage,
    String? profileCover,
    Location? location,
  }) =>
      TopCreatorItem(
        totalViews: totalViews ?? this.totalViews,
        creatorId: creatorId ?? this.creatorId,
        name: name ?? this.name,
        email: email ?? this.email,
        profileImage: profileImage ?? this.profileImage,
        profileCover: profileCover ?? this.profileCover,
        location: location ?? this.location,
      );

  factory TopCreatorItem.fromJson(Map<String, dynamic> json) => TopCreatorItem(
    totalViews: json["totalViews"],
    creatorId: json["creatorId"],
    name: json["name"],
    email: json["email"],
    profileImage: json["profile_image"],
    profileCover: json["profile_cover"],
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
  );

  Map<String, dynamic> toJson() => {
    "totalViews": totalViews,
    "creatorId": creatorId,
    "name": name,
    "email": email,
    "profile_image": profileImage,
    "profile_cover": profileCover,
    "location": location?.toJson(),
  };
}

class Location {
  final String? type;
  final List<num?>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  Location copyWith({
    String? type,
    List<num?>? coordinates,
  }) =>
      Location(
        type: type ?? this.type,
        coordinates: coordinates ?? this.coordinates,
      );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"],
    coordinates: json["coordinates"] == null ? [] : List<num?>.from(json["coordinates"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
  };
}
