class SearchCategoryModel {
  final bool? success;
  final String? message;
  final Data? data;

  SearchCategoryModel({
    this.success,
    this.message,
    this.data,
  });

  factory SearchCategoryModel.fromJson(Map<String, dynamic> json) =>
      SearchCategoryModel(
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
  final Category? category;
  final List<SubCategory>? subCategories;

  Data({
    this.category,
    this.subCategories,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        subCategories: json["subCategories"] == null
            ? []
            : List<SubCategory>.from(
                json["subCategories"]!.map((x) => SubCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category": category?.toJson(),
        "subCategories": subCategories == null
            ? []
            : List<dynamic>.from(subCategories!.map((x) => x.toJson())),
      };
}

class Category {
  final String? id;
  final String? title;
  final String? categoryImage;

  Category({
    this.id,
    this.title,
    this.categoryImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        title: json["title"],
        categoryImage: json["categoryImage"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "categoryImage": categoryImage,
      };
}

class SubCategory {
  final String? id;
  final String? title;
  final String? subCategoryImage;

  SubCategory({
    this.id,
    this.title,
    this.subCategoryImage,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["_id"],
        title: json["title"],
        subCategoryImage: json["subCategoryImage"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "subCategoryImage": subCategoryImage,
      };
}
