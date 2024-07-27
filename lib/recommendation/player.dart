import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PLayerScreen extends StatefulWidget {
  final String videoId;
  const PLayerScreen({
    super.key,
    required this.videoId,
  });

  @override
  State<PLayerScreen> createState() => _PLayerScreenState();
}

class _PLayerScreenState extends State<PLayerScreen> {
  late final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: widget.videoId,
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          //elevation: 0,
          // title: const Text(
          //   '',
          //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          // ),
          //centerTitle: true,
          //titleSpacing: 25,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/img/galaxy.jpeg"),
                  fit: BoxFit.cover),
            ),
            child: YoutubePlayerBuilder(
                player: YoutubePlayer(controller: _controller),
                builder: (context, player) {
                  return Column(
                    children: [
                      const Spacer(),
                      player,
                      const Spacer(),
                    ],
                  );
                })));
  }
}
