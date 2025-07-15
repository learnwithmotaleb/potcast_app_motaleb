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
  final String? id;
  final String? user;
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  final String? profileImage;
  final DateTime? dateOfBirth;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Data({
    this.location,
    this.id,
    this.user,
    this.name,
    this.phone,
    this.email,
    this.address,
    this.profileImage,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    id: json["_id"],
    user: json["user"],
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    address: json["address"],
    profileImage: json["profile_image"],
    dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "location": location?.toJson(),
    "_id": id,
    "user": user,
    "name": name,
    "phone": phone,
    "email": email,
    "address": address,
    "profile_image": profileImage,
    "dateOfBirth": dateOfBirth?.toIso8601String(),
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
