class TermsModel {
  final bool? success;
  final String? message;
  final Data? data;

  TermsModel({
    this.success,
    this.message,
    this.data,
  });

  TermsModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      TermsModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory TermsModel.fromJson(Map<String, dynamic> json) => TermsModel(
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
  final String? id;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;
  final String? dataId;

  Data({
    this.id,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.dataId,
  });

  Data copyWith({
    String? id,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    num? v,
    String? dataId,
  }) =>
      Data(
        id: id ?? this.id,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        dataId: dataId ?? this.dataId,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    description: json["description"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    dataId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "description": description,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "id": dataId,
  };
}
