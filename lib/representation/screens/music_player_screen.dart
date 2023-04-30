import 'package:flutter/material.dart';
import 'package:flutter_music_app/representation/models/song_model.dart';
import 'package:flutter_music_app/representation/widgets/seekbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  // int index = Get.arguments[2]['index'] ?? 0;
  List<Song> songList = Get.arguments[0]['songs'] ?? Song.songs;
  Song song = Get.arguments[1]["song"];

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
            onPressed: () {
              Get.toNamed("/");
            },
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
            _MusicPlayer(
              song: song,
              seekBarDataStream: _seekBarDataStream,
              audioPlayer: audioPlayer,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(left: 29),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Recommended",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
            PlaylistCard(
              songs: songList,
            ),
          ],
        ),
      ),
    );
  }
}

class _MusicPlayer extends StatelessWidget {
  const _MusicPlayer({
    super.key,
    required Stream<SeekBarData> seekBarDataStream,
    required this.audioPlayer,
    required this.song,
  }) : _seekBarDataStream = seekBarDataStream;

  final Stream<SeekBarData> _seekBarDataStream;
  final AudioPlayer audioPlayer;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<SeekBarData>(
            stream: _seekBarDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                //positionData?.position
                position: positionData?.position ?? Duration.zero,
                duration: positionData?.duration ?? Duration.zero,
                onChangeEnd: audioPlayer.seek,
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset(
                  song.coverUrl,
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
                    song.title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    song.description,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 8,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              StreamBuilder<SequenceState?>(
                stream: audioPlayer.sequenceStateStream,
                builder: (context, index) {
                  return IconButton(
                    onPressed: audioPlayer.hasPrevious
                        ? audioPlayer.seekToPrevious
                        : null,
                    iconSize: 40,
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.purple,
                    ),
                  );
                },
              ),
              StreamBuilder<PlayerState>(
                stream: audioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final playerState = snapshot.data;
                    final processingState = playerState!.processingState;

                    if (ProcessingState == ProcessingState.loading ||
                        ProcessingState == ProcessingState.buffering) {
                      return Container(
                        width: 64,
                        height: 64,
                        margin: const EdgeInsets.all(10),
                        child: const CircularProgressIndicator(),
                      );
                    } else if (!audioPlayer.playing) {
                      return IconButton(
                        onPressed: audioPlayer.play,
                        iconSize: 40,
                        icon: const Icon(
                          Icons.play_circle,
                          color: Colors.purple,
                        ),
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return IconButton(
                        onPressed: audioPlayer.pause,
                        icon: const Icon(
                          Icons.pause_circle,
                          color: Colors.purple,
                        ),
                        iconSize: 40,
                      );
                    } else {
                      return IconButton(
                        icon: const Icon(
                          Icons.replay_circle_filled_outlined,
                          color: Colors.purple,
                        ),
                        iconSize: 40,
                        onPressed: () => audioPlayer.seek(
                          Duration.zero,
                          index: audioPlayer.effectiveIndices!.first,
                        ),
                      );
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              StreamBuilder<SequenceState?>(
                stream: audioPlayer.sequenceStateStream,
                builder: (context, index) {
                  return IconButton(
                    onPressed:
                        audioPlayer.hasNext ? audioPlayer.seekToNext : null,
                    iconSize: 40,
                    icon: const Icon(
                      Icons.chevron_right,
                      color: Colors.purple,
                    ),
                  );
                },
              ),
            ],
          )
        ],
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
      padding: const EdgeInsets.only(left: 29, right: 29),
      child: ListView.builder(
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
      ),
    );
  }
}
