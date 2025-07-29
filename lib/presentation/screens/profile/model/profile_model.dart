class ProfileModel {
  final bool? success;
  final String? message;
  final Data? data;

  ProfileModel({
    this.success,
    this.message,
    this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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
  final Location? location;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? id;
  final String? user;
  final String? name;
  final String? email;
  final String? profileImage;
  final String? profileCover;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Data({
    this.location,
    this.dateOfBirth,
    this.gender,
    this.id,
    this.user,
    this.name,
    this.email,
    this.profileImage,
    this.profileCover,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
    gender: json["gender"],
    id: json["_id"],
    user: json["user"],
    name: json["name"],
    email: json["email"],
    profileImage: json["profile_image"],
    profileCover: json["profile_cover"],
    address: json["address"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "location": location?.toJson(),
    "dateOfBirth": dateOfBirth,
    "gender": gender,
    "_id": id,
    "user": user,
    "name": name,
    "email": email,
    "profile_image": profileImage,
    "profile_cover": profileCover,
    "address": address,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
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
