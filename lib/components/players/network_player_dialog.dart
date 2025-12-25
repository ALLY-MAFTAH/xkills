import 'dart:async';
import 'package:pod_player/pod_player.dart';
import 'package:flutter/material.dart';
import '/constants/endpoints.dart';
import '../../utils/get_video_id.dart';

class NetworkVideoPlayerDialog extends StatefulWidget {
  final int courseId;
  final int? lessonId;
  final String videoUrl;
  const NetworkVideoPlayerDialog({
    super.key,
    required this.courseId,
    this.lessonId,
    required this.videoUrl,
  });

  @override
  State<NetworkVideoPlayerDialog> createState() => _PlayVideoFromAssetState();
}

class _PlayVideoFromAssetState extends State<NetworkVideoPlayerDialog> {
  late final PodPlayerController controller;

  Timer? timer;

  @override
  void initState() {
    String fullUrl = "";
    if (widget.lessonId != null) {
      final videoFile = getVideoWithExtension(widget.videoUrl);
      fullUrl =
          "${Endpoints.baseUrl}/public/uploads/lesson_file/videos/$videoFile";
      print("LESSON ID: ${widget.lessonId}");
    } else {
      fullUrl = widget.videoUrl;
    }

    print("LESSON ID: ${widget.lessonId}");
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.networkQualityUrls(
        videoUrls: [
          VideoQalityUrls(quality: 360, url: fullUrl),
          VideoQalityUrls(quality: 720, url: fullUrl),
        ],
      ),
    )..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    if (widget.lessonId != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: PodVideoPlayer(
        controller: controller,
        podProgressBarConfig: const PodProgressBarConfig(
          playingBarColor: Colors.white,
          circleHandlerColor: Colors.white,
          backgroundColor: Colors.white30,
          padding: EdgeInsets.only(bottom: 20),
        ),
      ),
    );
  }
}
