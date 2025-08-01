class CategoriesSubcategoriesModel {
  final bool? success;
  final String? message;
  final Data? data;

  CategoriesSubcategoriesModel({
    this.success,
    this.message,
    this.data,
  });

  factory CategoriesSubcategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesSubcategoriesModel(
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
  final List<CategoryItem>? result;

  Data({
    this.meta,
    this.result,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    result: json["result"] == null ? [] : List<CategoryItem>.from(json["result"]!.map((x) => CategoryItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class Meta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

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

class CategoryItem {
  final String? id;
  final String? name;
  final String? categoryImage;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final List<Subcategory>? subcategories;
  final int? totalSubcategory;

  CategoryItem({
    this.id,
    this.name,
    this.categoryImage,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.subcategories,
    this.totalSubcategory,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
    id: json["_id"],
    name: json["name"],
    categoryImage: json["category_image"],
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    subcategories: json["subcategories"] == null ? [] : List<Subcategory>.from(json["subcategories"]!.map((x) => Subcategory.fromJson(x))),
    totalSubcategory: json["totalSubcategory"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "category_image": categoryImage,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "subcategories": subcategories == null ? [] : List<dynamic>.from(subcategories!.map((x) => x.toJson())),
    "totalSubcategory": totalSubcategory,
  };
}

class Subcategory {
  final String? id;
  final String? category;
  final String? name;
  final String? image;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Subcategory({
    this.id,
    this.category,
    this.name,
    this.image,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
    id: json["_id"],
    category: json["category"],
    name: json["name"],
    image: json["image"],
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "category": category,
    "name": name,
    "image": image,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
