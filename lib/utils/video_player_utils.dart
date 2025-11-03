// video_player_utils.dart

import 'package:flutter/material.dart';
import '../components/from_network.dart';
import '../components/from_vimeo_player.dart';
import '../components/youtube_video_player.dart';
import '../components/no_video_url.dart';

/// Handles routing to the correct video player based on the video URL type.
Future<void> navigateToVideoPlayer({
  required BuildContext context,
  required String videoUrl,
  required int courseId,
  required int? lessonId,
}) async {
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
  final isVimeo = videoUrl.contains("vimeo.com");
  final isDrive = videoUrl.contains("drive.google.com");
  final isMp4 = RegExp(r"\.mp4(\?|$)").hasMatch(videoUrl);
  final isWebm = RegExp(r"\.webm(\?|$)").hasMatch(videoUrl);
  final isOgg = RegExp(r"\.ogg(\?|$)").hasMatch(videoUrl);
  // -----------------------

  Widget nextPage;

  if (isYouTube) {
    nextPage = YoutubeVideoPlayer(
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
  } else if (isVimeo) {
    String vimeoVideoId = videoUrl.split('/').last;
    nextPage = FromVimeoPlayer(
      courseId: courseId,
      vimeoVideoId: vimeoVideoId,
      lessonId: lessonId,
    );
  } else if (isMp4 || isOgg || isWebm) {
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
