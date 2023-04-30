import 'package:flutter/material.dart';
import 'package:flutter_music_app/representation/models/song_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List<Song> songs = Song.songs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: Container(
            margin: const EdgeInsets.only(left: 29),
            child: IconButton(
              onPressed: () {},
              icon: const FaIcon(
                FontAwesomeIcons.bars,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 29),
              child: IconButton(
                // ignore: deprecated_member_use
                onPressed: () {},
                icon: const FaIcon(
                  FontAwesomeIcons.search,
                  color: Colors.black,
                ),
              ),
            )
          ],
          title: const Text(
            "Music Player",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _headerMusic(),
              const SizedBox(
                height: 12,
              ),
              _listViewAlbum(songs: songs),
              const SizedBox(
                height: 44,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 29),
                child: Text(
                  "Recommended",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PlaylistCard(songs: songs)
            ],
          ),
        ),
      ),
    );
  }
}

class PlaylistCard extends StatelessWidget {
  const PlaylistCard({
    super.key,
    required this.songs,
  });

  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 29, right: 29, top: 16),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: songs.length,
            itemBuilder: (context, index) {
              return Container(
                child: InkWell(
                  onTap: () {
                    Get.toNamed("/player", arguments: [
                      {"songs": songs},
                      {"song": songs[index]}
                    ]);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                          songs[index].coverUrl,
                          height: 32,
                          width: 32,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            songs[index].title,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            songs[index].description,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 8,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Text(
                        songs[index].time,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.ellipsis),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.bars),
                      )
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class _listViewAlbum extends StatelessWidget {
  const _listViewAlbum({
    // ignore: unused_element
    super.key,
    required this.songs,
  });

  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 29),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: songs.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(right: 20),
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                  image: AssetImage(
                    songs[index].coverUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class _headerMusic extends StatelessWidget {
  const _headerMusic({
    // ignore: unused_element
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 29, left: 29),
      child: Text(
        "Top album",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}
