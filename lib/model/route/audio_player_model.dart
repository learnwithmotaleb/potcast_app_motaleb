class AudioPlayerModel {
  final String id;
  final String title;
  final String? categories;
  final String image;
  final String? artist;
  final String duration;
  final String url;
  final bool reels;
  final bool popular;

  AudioPlayerModel({
    required this.id,
    required this.title,
    this.categories,
    required this.image,
    this.artist,
    required this.duration,
    required this.url,
    this.reels = false,
    this.popular = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'categories': categories,
      'image': image,
      'artist': artist,
      'duration': duration,
      'url': url,
      'reels': reels,
      'popular': popular,
    };
  }
}
