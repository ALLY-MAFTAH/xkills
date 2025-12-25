import 'dart:async';
import 'package:pod_player/pod_player.dart';
import 'package:flutter/material.dart';
import '../../constants/app_brand.dart';
import '/constants/endpoints.dart';
import '../../theme/app_colors.dart';
import '../../utils/get_video_id.dart';

class NetworkVideoPlayerFull extends StatefulWidget {
  static const routeName = '/fromNetwork';
  final int courseId;
  final int? lessonId;
  final String videoUrl;
  const NetworkVideoPlayerFull({
    super.key,
    required this.courseId,
    this.lessonId,
    required this.videoUrl,
  });

  @override
  State<NetworkVideoPlayerFull> createState() => _PlayVideoFromAssetState();
}

class _PlayVideoFromAssetState extends State<NetworkVideoPlayerFull> {
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

    // if (widget.lessonId != null) {
    //   timer = Timer.periodic(
    //       const Duration(seconds: 5), (Timer t) => updateWatchHistory());
    // }
  }

  // Future<void> updateWatchHistory() async {
  //   if (controller.isVideoPlaying) {
  //     var token = await SharedPreferenceHelper().getAuthToken();
  //     dynamic url;
  //     if (token != null && token.isNotEmpty) {
  //       url = "$BASE_URL/api/update_watch_history/$token";
  //       // print(url);
  //       // print(controller.currentVideoPosition.inSeconds);
  //       try {
  //         final response = await http.post(
  //           Uri.parse(url),
  //           body: {
  //             'course_id': widget.courseId.toString(),
  //             'lesson_id': widget.lessonId.toString(),
  //             'current_duration':
  //                 controller.currentVideoPosition.inSeconds.toString(),
  //           },
  //         );

  //         final responseData = json.decode(response.body);
  //         // print(responseData);
  //         if (responseData == null) {
  //           return;
  //         } else {
  //           var isCompleted = responseData['is_completed'];
  //           if (isCompleted == 1) {
  //             Provider.of<MyCourses>(context, listen: false)
  //                 .updateDripContendLesson(
  //                     widget.courseId,
  //                     responseData['course_progress'],
  //                     responseData['number_of_completed_lessons']);
  //           }
  //         }
  //       } catch (error) {
  //         rethrow;
  //       }
  //     } else {
  //       return;
  //     }
  //   }
  // }

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background gradient (same as YouTube screen)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.secondaryColor, AppColors.primaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),

          appBrand(context: context, hasBackButton: true),

          // Video Player (center)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: PodVideoPlayer(
                controller: controller,
                podProgressBarConfig: const PodProgressBarConfig(
                  playingBarColor: Colors.white,
                  circleHandlerColor: Colors.white,
                  backgroundColor: Colors.white30,
                  padding: EdgeInsets.only(bottom: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
