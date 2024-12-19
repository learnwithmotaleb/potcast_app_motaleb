class AudioPlayerModel {
  final String id;
  final String? title;
  final String? categories;
  final String? image;
  final String? artist;
  final String? duration;
  final String? url;

  AudioPlayerModel({
    required this.id,
    this.title,
    this.categories,
    this.image,
    this.artist,
    this.duration,
    this.url,
  });
}
