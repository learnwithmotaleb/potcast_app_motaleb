class PlayListModel {
  final bool? success;
  final String? message;
  final Data? data;

  PlayListModel({
    this.success,
    this.message,
    this.data,
  });

  factory PlayListModel.fromJson(Map<String, dynamic> json) => PlayListModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  final List<Playlist>? playlists;

  Data({
    this.playlists,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    playlists: json["playlists"] == null ? [] : List<Playlist>.from(json["playlists"]!.map((x) => Playlist.fromJson(x))),
  );
}

class Playlist {
  final String? id;
  final String? title;
  final String? cover;
  final num? total;

  Playlist({
    this.id,
    this.title,
    this.cover,
    this.total,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
    id: json["_id"],
    title: json["title"],
    cover: json["cover"],
    total: json["total"],
  );
}

