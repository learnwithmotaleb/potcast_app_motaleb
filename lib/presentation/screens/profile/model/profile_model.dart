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
}

class Data {
  final String? name;
  final String? dateOfBirth;
  final String? gender;
  final String? contact;
  final String? address;
  final String? avatar;
  final String? email;

  Data({
    this.name,
    this.dateOfBirth,
    this.gender,
    this.contact,
    this.address,
    this.avatar,
    this.email,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    name: json["name"],
    dateOfBirth: json["dateOfBirth"],
    gender: json["gender"],
    contact: json["contact"],
    address: json["address"],
    avatar: json["avatar"],
    email: json["email"],
  );
}
