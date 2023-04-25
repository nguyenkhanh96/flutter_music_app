import 'package:flutter/material.dart';
import 'package:flutter_music_app/representation/models/song_model.dart';
import 'package:flutter_music_app/representation/widgets/seekbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  Song song = Song.songs[0];

  @override
  void initState() {
    super.initState();

    audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: [
          AudioSource.uri(
            Uri.parse('asset:///${song.url}'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Stream<SeekBarData> get _seekBarDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
          audioPlayer.positionStream, audioPlayer.durationStream, (
        Duration position,
        Duration? duration,
      ) {
        return SeekBarData(
          position,
          duration ?? Duration.zero,
        );
      });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 450,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    child: Image.asset(
                      "assets/images/image_yellow.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 80,
                    right: 80,
                    top: 130,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/images/image_album_1_lager.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              "Hip hop",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            const Text(
              "ABHIFLIX",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 10,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 29, right: 29),
                  child: Text(
                    "Recommended",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 10),
                  ),
                ),
                PlaylistCard(
                  songs: Song.songs,
                )
              ],
            ),
          ],
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
              );
            },
          )
        ],
      ),
    );
  }
}

// 27s03
