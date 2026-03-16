import 'dart:convert';
import 'package:podcast/presentation/screens/play/model/play_feed_model.dart';

class PlayEntity {
  final String id;
  final String title;
  final String podcastUrl;
  final String coverImage;
  final String? categoryName;
  final String? subCategoryName;
  final String? creatorName;
  final String? donationLink;
  final num? duration;
  final bool? isBookmark;
  final bool? isLike;
  final String? creatorId;

  const PlayEntity({
    required this.id,
    required this.title,
    required this.podcastUrl,
    required this.coverImage,
    this.categoryName,
    this.subCategoryName,
    this.creatorName,
    this.donationLink,
    this.duration,
    this.isBookmark,
    this.isLike,
    this.creatorId,
  });

  PlayEntity copyWith({
    String? id,
    String? title,
    String? podcastUrl,
    String? coverImage,
    String? categoryName,
    String? subCategoryName,
    String? creatorName,
    String? donationLink,
    num? duration,
    bool? isBookmark,
    bool? isLike,
    String? creatorId,
  }) {
    return PlayEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      podcastUrl: podcastUrl ?? this.podcastUrl,
      coverImage: coverImage ?? this.coverImage,
      categoryName: categoryName ?? this.categoryName,
      subCategoryName: subCategoryName ?? this.subCategoryName,
      creatorName: creatorName ?? this.creatorName,
      donationLink: donationLink ?? this.donationLink,
      duration: duration ?? this.duration,
      isBookmark: isBookmark ?? this.isBookmark,
      isLike: isLike ?? this.isLike,
      creatorId: creatorId ?? this.creatorId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'podcastUrl': podcastUrl,
      'coverImage': coverImage,
      'categoryName': categoryName,
      'subCategoryName': subCategoryName,
      'creatorName': creatorName,
      'donationLink': donationLink,
      'duration': duration,
      'isBookmark': isBookmark,
      'isLike': isLike,
      'creatorId': creatorId,
    };
  }

  factory PlayEntity.fromMap(Map<String, dynamic> map) {
    return PlayEntity(
      id: map['id'] as String,
      title: map['title'] as String,
      podcastUrl: map['podcastUrl'] as String,
      coverImage: map['coverImage'] as String,
      categoryName: map['categoryName'] as String?,
      subCategoryName: map['subCategoryName'] as String?,
      creatorName: map['creatorName'] as String?,
      donationLink: map['donationLink'] as String?,
      duration: map['duration'] is int
          ? (map['duration'] as int).toDouble()
          : map['duration'] as num?,
      isBookmark: map['isBookmark'] as bool?,
      isLike: map['isLike'] as bool?,
      creatorId: map['creatorId'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayEntity.fromJson(String source) =>
      PlayEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlayEntity(id: $id, title: $title, podcastUrl: $podcastUrl, coverImage: $coverImage, '
        'categoryName: $categoryName, subCategoryName: $subCategoryName, '
        'creatorName: $creatorName, donationLink: $donationLink, '
        'duration: $duration, isBookmark: $isBookmark, isLike: $isLike, creatorId: $creatorId)';
  }

  static PlayEntity? fromPodcast(PlayPodcastItem item) {
    if (item.id == null ||
        item.title == null ||
        item.podcastUrl == null ||
        item.coverImage == null) {
      return null;
    }

    return PlayEntity(
      id: item.id!,
      title: item.title!,
      podcastUrl: item.podcastUrl!,
      coverImage: item.coverImage!,
      categoryName: item.category?.name,
      subCategoryName: item.subCategory?.name,
      creatorName: item.creator?.name,
      donationLink: item.creator?.donationLink,
      duration: item.duration,
      isBookmark: item.isBookmark,
      isLike: item.isLike,
      creatorId: item.creator?.id,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlayEntity &&
        other.id == id &&
        other.title == title &&
        other.podcastUrl == podcastUrl &&
        other.coverImage == coverImage &&
        other.categoryName == categoryName &&
        other.subCategoryName == subCategoryName &&
        other.creatorName == creatorName &&
        other.donationLink == donationLink &&
        other.duration == duration &&
        other.isBookmark == isBookmark &&
        other.isLike == isLike &&
        other.creatorId == creatorId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    title.hashCode ^
    podcastUrl.hashCode ^
    coverImage.hashCode ^
    categoryName.hashCode ^
    subCategoryName.hashCode ^
    creatorName.hashCode ^
    donationLink.hashCode ^
    duration.hashCode ^
    isBookmark.hashCode ^
    isLike.hashCode ^
    creatorId.hashCode;
  }
}
