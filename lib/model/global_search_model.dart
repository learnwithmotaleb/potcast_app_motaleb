class GlobalSearchModel {
  final bool success;
  final String message;
  final GlobalSearchData? data;

  GlobalSearchModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory GlobalSearchModel.fromJson(Map<String, dynamic> json) {
    return GlobalSearchModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null ? GlobalSearchData.fromJson(json["data"]) : null,
    );
  }
}

class GlobalSearchData {
  final GlobalSearchMeta? meta;
  final List<GlobalSearchResultItem> data;

  GlobalSearchData({
    this.meta,
    required this.data,
  });

  factory GlobalSearchData.fromJson(Map<String, dynamic> json) {
    return GlobalSearchData(
      meta: json["meta"] != null ? GlobalSearchMeta.fromJson(json["meta"]) : null,
      data: json["data"] != null
          ? List<GlobalSearchResultItem>.from(
              json["data"].map((x) => GlobalSearchResultItem.fromJson(x)))
          : [],
    );
  }
}

class GlobalSearchMeta {
  final int total;
  final int? totalPages;

  GlobalSearchMeta({
    required this.total,
    this.totalPages,
  });

  factory GlobalSearchMeta.fromJson(Map<String, dynamic> json) {
    return GlobalSearchMeta(
      total: json["total"] ?? 0,
      totalPages: json["totalPages"],
    );
  }
}

class GlobalSearchResultItem {
  final String id;
  final String type;
  final String title;
  final String image;
  final String? url;
  final String? createdAt;
  final num score;

  GlobalSearchResultItem({
    required this.id,
    required this.type,
    required this.title,
    required this.image,
    this.url,
    this.createdAt,
    required this.score,
  });

  factory GlobalSearchResultItem.fromJson(Map<String, dynamic> json) {
    return GlobalSearchResultItem(
      id: json["id"] ?? "",
      type: json["type"] ?? "podcast",
      title: json["title"] ?? json["name"] ?? "",
      image: json["image"] ?? "",
      url: json["url"] ?? json["podcastUrl"],
      createdAt: json["createdAt"],
      score: json["score"] ?? 0,
    );
  }
}
