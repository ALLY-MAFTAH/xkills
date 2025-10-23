import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constants/app_brand.dart';
import '../theme/app_colors.dart';

// Define the main widget for the YouTube video player
class YoutubeVideoPlayerFlutter extends StatefulWidget {
  final int courseId;
  final int? lessonId;
  final String videoUrl;
  const YoutubeVideoPlayerFlutter({
    super.key,
    required this.courseId,
    this.lessonId,
    required this.videoUrl,
  });

  @override
  State<YoutubeVideoPlayerFlutter> createState() =>
      _YoutubeVideoPlayerFlutterState();
}

class _YoutubeVideoPlayerFlutterState extends State<YoutubeVideoPlayerFlutter> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  // Method to seek forward 10 seconds
  void seekForward() {
    final currentPosition = _controller.value.position;
    final duration = _controller.value.metaData.duration;
    if (currentPosition.inSeconds + 10 < duration.inSeconds) {
      _controller.seekTo(currentPosition + const Duration(seconds: 10));
    }
  }

  // Method to seek backward 10 seconds
  void seekBackward() {
    final currentPosition = _controller.value.position;
    if (currentPosition.inSeconds - 10 > 0) {
      _controller.seekTo(currentPosition - const Duration(seconds: 10));
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      // onExitFullScreen and player definition are correct here (keep them!)
      // onExitFullScreen: () {
      //   // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
      //   SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      // },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(color: Colors.white, fontSize: 18.0),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 25.0),
            onPressed: () {
              log('Settings Tapped!');
            },
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
      ),
      builder:
          (context, player) => Scaffold(
            // 'player' here is the correct widget
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              leading: null,
              automaticallyImplyLeading: false,
              title: appBrand(),
              backgroundColor: Colors.transparent,
              toolbarHeight: Platform.isAndroid ? 60 : 30,
            ),
            body: Stack(
              children: [
                // 1. Background Gradient
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.secondaryColor,
                        AppColors.primaryColor,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 15,
                  left: 10,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 28,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),

                Center(child: player),

                Visibility(
                  visible: false,
                  child: Positioned(
                    top: 100,
                    right: 100,
                    left: 100,
                    bottom: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: seekBackward,
                          icon: const Icon(
                            Icons.replay_10,
                            size: 30,
                            color: Colors.white54,
                          ),
                        ),
                        const SizedBox(width: 30),
                        IconButton(
                          onPressed: seekForward,
                          icon: const Icon(
                            Icons.forward_10,
                            size: 30,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
