class HomeModel {
  final bool? success;
  final String? message;
  final Data? data;

  HomeModel({
    this.success,
    this.message,
    this.data,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
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
  final List<CategoryElement>? categories;
  final List<Podcast>? newestPodcasts;
  final List<Podcast>? popularPodcasts;
  final List<Podcast>? reels;
  final List<Podcast>? albums;
  final List<TopCreator>? topCreators;

  Data({
    this.categories,
    this.newestPodcasts,
    this.popularPodcasts,
    this.reels,
    this.albums,
    this.topCreators,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    categories: json["categories"] == null ? [] : List<CategoryElement>.from(json["categories"]!.map((x) => CategoryElement.fromJson(x))),
    newestPodcasts: json["newestPodcasts"] == null ? [] : List<Podcast>.from(json["newestPodcasts"]!.map((x) => Podcast.fromJson(x))),
    popularPodcasts: json["popularPodcasts"] == null ? [] : List<Podcast>.from(json["popularPodcasts"]!.map((x) => Podcast.fromJson(x))),
    reels: json["reels"] == null ? [] : List<Podcast>.from(json["reels"]!.map((x) => x)),
    albums: json["albums"] == null ? [] : List<Podcast>.from(json["albums"]!.map((x) => x)),
    topCreators: json["topCreators"] == null ? [] : List<TopCreator>.from(json["topCreators"]!.map((x) => TopCreator.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "newestPodcasts": newestPodcasts == null ? [] : List<dynamic>.from(newestPodcasts!.map((x) => x.toJson())),
    "popularPodcasts": popularPodcasts == null ? [] : List<dynamic>.from(popularPodcasts!.map((x) => x.toJson())),
    "reels": reels == null ? [] : List<dynamic>.from(reels!.map((x) => x)),
    "albums": albums == null ? [] : List<dynamic>.from(albums!.map((x) => x)),
    "topCreators": topCreators == null ? [] : List<dynamic>.from(topCreators!.map((x) => x.toJson())),
  };
}

class CategoryElement {
  final String? id;
  final String? name;
  final String? categoryImage;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;

  CategoryElement({
    this.id,
    this.name,
    this.categoryImage,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CategoryElement.fromJson(Map<String, dynamic> json) => CategoryElement(
    id: json["_id"],
    name: json["name"],
    categoryImage: json["category_image"],
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "category_image": categoryImage,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class Podcast {
  final Location? location;
  final String? id;
  final String? creator;
  final String? category;
  final String? subCategory;
  final String? coverImage;
  final String? audioUrl;
  final String? title;
  final String? description;
  final String? address;
  final List<String>? tags;
  final num? totalView;
  final num? duration;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;

  Podcast({
    this.location,
    this.id,
    this.creator,
    this.category,
    this.subCategory,
    this.coverImage,
    this.audioUrl,
    this.title,
    this.description,
    this.address,
    this.tags,
    this.totalView,
    this.duration,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) => Podcast(
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    id: json["_id"],
    creator: json["creator"],
    category: json["category"],
    subCategory: json["subCategory"],
    coverImage: json["coverImage"],
    audioUrl: json["audio_url"],
    title: json["title"],
    description: json["description"],
    address: json["address"],
    tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
    totalView: json["totalView"],
    duration: json["duration"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "location": location?.toJson(),
    "_id": id,
    "creator": creator,
    "category": category,
    "subCategory": subCategory,
    "coverImage": coverImage,
    "audio_url": audioUrl,
    "title": title,
    "description": description,
    "address": address,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "totalView": totalView,
    "duration": duration,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class Location {
  final String? type;
  final List<num>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"],
    coordinates: json["coordinates"] == null ? [] : List<int>.from(json["coordinates"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
  };
}

class TopCreator {
  final num? totalViews;
  final String? creatorId;
  final String? name;
  final String? email;
  final String? profileImage;
  final String? profileCover;
  final Location? location;

  TopCreator({
    this.totalViews,
    this.creatorId,
    this.name,
    this.email,
    this.profileImage,
    this.profileCover,
    this.location,
  });

  factory TopCreator.fromJson(Map<String, dynamic> json) => TopCreator(
    totalViews: json["totalViews"],
    creatorId: json["creatorId"],
    name: json["name"],
    email: json["email"],
    profileImage: json["profile_image"],
    profileCover: json["profile_cover"],
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
  );

  Map<String, dynamic> toJson() => {
    "totalViews": totalViews,
    "creatorId": creatorId,
    "name": name,
    "email": email,
    "profile_image": profileImage,
    "profile_cover": profileCover,
    "location": location?.toJson(),
  };
}
