// video_player_utils.dart

import 'package:flutter/material.dart';
import '../components/from_network.dart';
import '../components/youtube_player_full.dart';
import '../components/no_video_url.dart';

/// Handles routing to the correct video player based on the video URL type.
Future<void> navigateToVideoPlayer({
  required BuildContext context,
  required String videoUrl,
  required int courseId,
  required int? lessonId,
}) async {
  print("VIDEO DATA::::: $videoUrl");
  if (videoUrl.isEmpty) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoVideoUrl()),
    );
    debugPrint("Video URL is null or empty");
    return;
  }

  // --- URL Type Checks ---
  final isYouTube =
      videoUrl.contains("youtube.com") || videoUrl.contains("youtu.be");
  final isDrive = videoUrl.contains("drive.google.com");
  final isMp4 = RegExp(r"\.mp4(\?|$)").hasMatch(videoUrl);
  final isWebm = RegExp(r"\.webm(\?|$)").hasMatch(videoUrl);
  final isOgg = RegExp(r"\.ogg(\?|$)").hasMatch(videoUrl);
  final isMkv = RegExp(r"\.mkv(\?|$)").hasMatch(videoUrl);
  // -----------------------

  Widget nextPage;

  if (isYouTube) {
    nextPage = YoutubePlayerFull(
      courseId: courseId,
      lessonId: lessonId,
      videoUrl: videoUrl,
    );
  } else if (isDrive) {
    final RegExp regExp = RegExp(r'[-\w]{25,}');
    final Match? match = regExp.firstMatch(videoUrl);

    if (match != null) {
      String driveUrl =
          'https://drive.google.com/uc?export=download&id=${match.group(0)}';
      nextPage = PlayVideoFromNetwork(
        courseId: courseId,
        lessonId: lessonId,
        videoUrl: driveUrl,
      );
    } else {
      nextPage = NoVideoUrl();
    }
  } else if (isMp4 || isOgg || isWebm || isMkv) {
    nextPage = PlayVideoFromNetwork(
      courseId: courseId,
      lessonId: lessonId,
      videoUrl: videoUrl,
    );
  } else {
    nextPage = NoVideoUrl();
  }

  // --- Navigation ---
  Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage));
}
