class PodcastCategoriesModel {
  final bool? success;
  final String? message;
  final List<CategoriesData>? data;

  PodcastCategoriesModel({
    this.success,
    this.message,
    this.data,
  });

  factory PodcastCategoriesModel.fromJson(Map<String, dynamic> json) => PodcastCategoriesModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<CategoriesData>.from(json["data"]!.map((x) => CategoriesData.fromJson(x))),
  );
}

class CategoriesData {
  final String? id;
  final String? title;
  final List<SubCategory>? subCategories;

  CategoriesData({
    this.id,
    this.title,
    this.subCategories,
  });

  factory CategoriesData.fromJson(Map<String, dynamic> json) => CategoriesData(
    id: json["_id"],
    title: json["title"],
    subCategories: json["subCategories"] == null ? [] : List<SubCategory>.from(json["subCategories"]!.map((x) => SubCategory.fromJson(x))),
  );
}

class SubCategory {
  final String? id;
  final String? title;

  SubCategory({
    this.id,
    this.title,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    id: json["_id"],
    title: json["title"],
  );
}
