class AudioPlayerModel {
  final String id;
  final String title;
  final String? categories;
  final String image;
  final String? artist;
  final String? creatorImage;
  final String duration;
  final String url;
  final bool reels;
  final bool popular;
  final bool isAlbum;
  final bool isPlaylist;
  final bool isCreator;
  final String? stationId;
  final String? firstPodcastId;

  AudioPlayerModel({
    required this.id,
    required this.title,
    this.categories,
    required this.image,
    this.artist,
    this.creatorImage,
    required this.duration,
    required this.url,
    this.reels = false,
    this.popular = false,
    this.isAlbum = false,
    this.isPlaylist = false,
    this.isCreator = false,
    this.stationId,
    this.firstPodcastId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'categories': categories,
      'image': image,
      'artist': artist,
      'creatorImage': creatorImage,
      'duration': duration,
      'url': url,
      'reels': reels,
      'popular': popular,
      'isAlbum': isAlbum,
      'isPlaylist': isPlaylist,
      'isCreator': isCreator,
      'stationId': stationId,
      'firstPodcastId': firstPodcastId,
    };
  }
}
