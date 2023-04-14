import 'package:flutter/material.dart';

class Song {
  final String title;
  final String description;
  final String url;
  final String coverUrl;

  Song({
    required this.title,
    required this.description,
    required this.url,
    required this.coverUrl,
  });

  static List<Song> songs = [
    Song(
      title: "Anh Nang Cua Anh",
      description: "Duc Phuc",
      url: "assets/music/anhnangcuaanh.mp3",
      coverUrl: "assets/images/image_album_1.png",
    ),
    Song(
      title: "Sau Tim Thiep Hong",
      description: "Quang Le",
      url: "assets/music/sautimthiephong.mp3",
      coverUrl: "assets/images/image_album_1.png",
    ),
    Song(
      title: "Tell Me Good Bye",
      description: "Duc Phuc",
      url: "assets/music/tellmegoodbye.mp3",
      coverUrl: "assets/images/image_album_1.png",
    )
  ];
}
