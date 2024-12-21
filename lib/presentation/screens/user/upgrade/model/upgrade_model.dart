class PlanModel {
  final bool? success;
  final String? message;
  final List<Plan>? data;

  PlanModel({
    this.success,
    this.message,
    this.data,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Plan>.from(json["data"]!.map((x) => Plan.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Plan {
  final String? id;
  final String? name;
  final String? description;
  final int? unitAmount;
  final String? interval;
  final String? productId;
  final String? priceId;
  final int? v;

  Plan({
    this.id,
    this.name,
    this.description,
    this.unitAmount,
    this.interval,
    this.productId,
    this.priceId,
    this.v,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    unitAmount: json["unitAmount"],
    interval: json["interval"],
    productId: json["productId"],
    priceId: json["priceId"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "unitAmount": unitAmount,
    "interval": interval,
    "productId": productId,
    "priceId": priceId,
    "__v": v,
  };
}
