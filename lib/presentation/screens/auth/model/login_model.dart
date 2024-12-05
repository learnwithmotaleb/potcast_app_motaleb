class LoginModel {
  final bool? success;
  final String? message;
  final Data? data;

  LoginModel({
    this.success,
    this.message,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  final String? accessToken;
  final Auth? auth;

  Data({
    this.accessToken,
    this.auth,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    accessToken: json["accessToken"],
    auth: json["auth"] == null ? null : Auth.fromJson(json["auth"]),
  );
}

class Auth {
  final String? id;
  final String? email;
  final String? password;
  final String? role;
  final bool? isVerified;
  final bool? isBlocked;
  final String? subscriptionType;

  Auth({
    this.id,
    this.email,
    this.password,
    this.role,
    this.isVerified,
    this.isBlocked,
    this.subscriptionType,
  });

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
    id: json["_id"],
    email: json["email"],
    password: json["password"],
    role: json["role"],
    isVerified: json["isVerified"],
    isBlocked: json["isBlocked"],
    subscriptionType: json["subscriptionType"],
  );
}
