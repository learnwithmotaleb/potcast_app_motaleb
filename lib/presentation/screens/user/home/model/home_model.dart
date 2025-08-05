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
  final List<HomeCategoryElement>? categories;
  final List<HomeNewestPodcast>? newestPodcasts;
  final List<HomeNewestPodcast>? popularPodcasts;
  final List<HomeNewestPodcast>? reels;
  final List<HomeAlbumItem>? albums;
  final List<HomeTopCreator>? topCreators;

  Data({
    this.categories,
    this.newestPodcasts,
    this.popularPodcasts,
    this.reels,
    this.albums,
    this.topCreators,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    categories: json["categories"] == null ? [] : List<HomeCategoryElement>.from(json["categories"]!.map((x) => HomeCategoryElement.fromJson(x))),
    newestPodcasts: json["newestPodcasts"] == null ? [] : List<HomeNewestPodcast>.from(json["newestPodcasts"]!.map((x) => HomeNewestPodcast.fromJson(x))),
    popularPodcasts: json["popularPodcasts"] == null ? [] : List<HomeNewestPodcast>.from(json["popularPodcasts"]!.map((x) => HomeNewestPodcast.fromJson(x))),
    reels: json["reels"] == null ? [] : List<HomeNewestPodcast>.from(json["reels"]!.map((x) => HomeNewestPodcast.fromJson(x))),
    albums: json["albums"] == null ? [] : List<HomeAlbumItem>.from(json["albums"]!.map((x) => HomeAlbumItem.fromJson(x))),
    topCreators: json["topCreators"] == null ? [] : List<HomeTopCreator>.from(json["topCreators"]!.map((x) => HomeTopCreator.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "newestPodcasts": newestPodcasts == null ? [] : List<dynamic>.from(newestPodcasts!.map((x) => x.toJson())),
    "popularPodcasts": popularPodcasts == null ? [] : List<dynamic>.from(popularPodcasts!.map((x) => x.toJson())),
    "reels": reels == null ? [] : List<dynamic>.from(reels!.map((x) => x.toJson())),
    "albums": albums == null ? [] : List<dynamic>.from(albums!.map((x) => x.toJson())),
    "topCreators": topCreators == null ? [] : List<dynamic>.from(topCreators!.map((x) => x.toJson())),
  };
}

class HomeAlbumItem {
  final String? id;
  final String? name;
  final String? description;
  final List<String>? tags;
  final String? coverImage;
  final List<String>? podcasts;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;

  HomeAlbumItem({
    this.id,
    this.name,
    this.description,
    this.tags,
    this.coverImage,
    this.podcasts,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory HomeAlbumItem.fromJson(Map<String, dynamic> json) => HomeAlbumItem(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
    coverImage: json["cover_image"],
    podcasts: json["podcasts"] == null ? [] : List<String>.from(json["podcasts"]!.map((x) => x)),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "cover_image": coverImage,
    "podcasts": podcasts == null ? [] : List<dynamic>.from(podcasts!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
class HomeCategoryElement {
  final String? id;
  final String? name;
  final String? categoryImage;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  HomeCategoryElement({
    this.id,
    this.name,
    this.categoryImage,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory HomeCategoryElement.fromJson(Map<String, dynamic> json) => HomeCategoryElement(
    id: json["_id"],
    name: json["name"],
    categoryImage: json["category_image"],
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "category_image": categoryImage,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class HomeNewestPodcast {
  final Location? location;
  final String? id;
  final HomeCreator? creator;
  final SubCategoryClass? category;
  final SubCategoryClass? subCategory;
  final String? coverImage;
  final String? audioUrl;
  final String? title;
  final String? description;
  final String? address;
  final List<String?>? tags;
  final num? totalView;
  final num? duration;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;

  HomeNewestPodcast({
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

  factory HomeNewestPodcast.fromJson(Map<String, dynamic> json) => HomeNewestPodcast(
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    id: json["_id"],
    creator: json["creator"] == null ? null : HomeCreator.fromJson(json["creator"]),
    category: json["category"] == null ? null : SubCategoryClass.fromJson(json["category"]),
    subCategory: json["subCategory"] == null ? null : SubCategoryClass.fromJson(json["subCategory"]),
    coverImage: json["coverImage"],
    audioUrl: json["audio_url"],
    title: json["title"],
    description: json["description"],
    address: json["address"],
    tags: json["tags"] == null ? [] : List<String?>.from(json["tags"]?.map((x) => x)),
    totalView: json["totalView"],
    duration: json["duration"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "location": location?.toJson(),
    "_id": id,
    "creator": creator?.toJson(),
    "category": category?.toJson(),
    "subCategory": subCategory?.toJson(),
    "coverImage": coverImage,
    "audio_url": audioUrl,
    "title": title,
    "description": description,
    "address": address,
    "tags": tags == null ? [] : List<String?>.from(tags!.map((x) => x)),
    "totalView": totalView,
    "duration": duration,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class HomeCreator {
  final String? id;
  final String? name;
  final String? profileImage;

  HomeCreator({
    this.id,
    this.name,
    this.profileImage,
  });

  factory HomeCreator.fromJson(Map<String, dynamic> json) => HomeCreator(
    id: json["_id"],
    name: json["name"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "profile_image": profileImage,
  };
}


class SubCategoryClass {
  final String? id;
  final String? name;

  SubCategoryClass({
    this.id,
    this.name,
  });

  factory SubCategoryClass.fromJson(Map<String, dynamic> json) => SubCategoryClass(
    id: json["_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
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
    coordinates: json["coordinates"] == null ? [] : List<num>.from(json["coordinates"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
  };
}

class HomeTopCreator {
  final num? totalViews;
  final String? creatorId;
  final String? name;
  final String? email;
  final String? profileImage;
  final String? profileCover;
  final Location? location;

  HomeTopCreator({
    this.totalViews,
    this.creatorId,
    this.name,
    this.email,
    this.profileImage,
    this.profileCover,
    this.location,
  });

  factory HomeTopCreator.fromJson(Map<String, dynamic> json) => HomeTopCreator(
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
