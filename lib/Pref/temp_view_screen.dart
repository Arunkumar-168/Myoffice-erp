import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TempViewScreen extends StatefulWidget {
  static const routeName = '/temp-view';
  final String? videoUrl;

  const TempViewScreen({Key? key, this.videoUrl}) : super(key: key);

  @override
  _TempViewScreenState createState() => _TempViewScreenState();
}

class _TempViewScreenState extends State<TempViewScreen> {
  late VideoPlayerController _controller;
  late FlickManager flickManager;
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    print(widget.videoUrl.toString());
    _controller = VideoPlayerController.network(widget.videoUrl.toString());
    flickManager = FlickManager(videoPlayerController: _controller);
    _youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl!) ?? '',
    );
    WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter engine is initialized
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    flickManager.dispose();
    // Reset preferred orientations to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.of(context).pushNamed(TempViewScreen.routeName);

                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fill,
              child: YoutubePlayer(
                controller: _youtubeController,
                showVideoProgressIndicator: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}