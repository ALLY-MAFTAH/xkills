import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../controllers/course_controller.dart';
import '/models/course.dart';
import '../theme/app_colors.dart';
import 'custom_loader.dart';
import 'players/network_player_dialog.dart';
import 'pack_info_footer.dart';
import 'players/youtube_player_dialog.dart';

class GridPackCard extends StatefulWidget {
  final Course thisPack;
  final VoidCallback onBuyPressed;
  final VoidCallback onAddToCartPressed;
  const GridPackCard({
    super.key,
    required this.thisPack,
    required this.onBuyPressed,
    required this.onAddToCartPressed,
  });

  @override
  State<GridPackCard> createState() => _GridPackCardState();
}

class _GridPackCardState extends State<GridPackCard> {
  final courseController = Get.put(CourseController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: const Color.fromARGB(255, 16, 16, 16),
              border: Border.all(color: Colors.grey, width: .5),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: (Get.width / 4) + 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PackInfoFooter(
                      thisPack: widget.thisPack,
                      onBookmarkPressed: () {},
                    ),
                    SizedBox(height: 10),
                    GetBuilder<CourseController>(
                      builder: (courseController) {
                        bool hasEnrolled = courseController.myPacks.any(
                          (course) => course.id == widget.thisPack.id,
                        );
                        if (hasEnrolled) {
                          final isDownloading =
                              courseController.isDownloading[widget
                                  .thisPack
                                  .id] ??
                              false;
                          final progress =
                              courseController.downloadProgress[widget
                                  .thisPack
                                  .id] ??
                              0;
                          final isPaused =
                              courseController.isPaused[widget.thisPack.id] ??
                              false;

                          return gradientButtonWrapper(
                            radius: 10,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!isDownloading) {
                                  courseController.downloadCourse(
                                    widget.thisPack.id!,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child:
                                  isDownloading
                                      ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                TweenAnimationBuilder<double>(
                                                  tween: Tween<double>(
                                                    begin: 0,
                                                    end: progress,
                                                  ),
                                                  duration: Duration(
                                                    milliseconds: 400,
                                                  ),
                                                  curve: Curves.easeOut,
                                                  builder: (
                                                    context,
                                                    value,
                                                    child,
                                                  ) {
                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      child: LinearProgressIndicator(
                                                        value: value,
                                                        minHeight: 10,
                                                        backgroundColor: Colors
                                                            .white
                                                            .withOpacity(0.3),
                                                        color:
                                                            AppColors
                                                                .tertiaryColor,
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Text(
                                                  "${(progress * 100).toStringAsFixed(0)}%",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          IconButton(
                                            onPressed: () {
                                              isPaused
                                                  ? courseController
                                                      .resumeDownload(
                                                        widget.thisPack.id!,
                                                      )
                                                  : courseController
                                                      .pauseDownload(
                                                        widget.thisPack.id!,
                                                      );
                                            },
                                            icon: Icon(
                                              isPaused
                                                  ? Icons.play_arrow_rounded
                                                  : Icons.pause_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              courseController.cancelDownload(
                                                widget.thisPack.id!,
                                              );
                                            },
                                            icon: Icon(
                                              Icons.close_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )
                                      : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.download_rounded,
                                            color: Colors.black,
                                            size: 16,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Download".tr,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                            ),
                          );
                        } else {
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final isSmall = constraints.maxWidth < 200;

                              return isSmall
                                  ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      _buildBuyButton(),
                                      const SizedBox(height: 8),
                                      _buildCartButton(),
                                    ],
                                  )
                                  : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: _buildBuyButton(),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: _buildCartButton(),
                                      ),
                                    ],
                                  );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: 0,
          bottom: 0,
          child: Container(
            height: Get.height / 4,
            width: Get.width / 4,
            decoration: BoxDecoration(color: Colors.transparent),
            child:
                widget.thisPack.thumbnail!.isNotEmpty
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        // imageUrl:  "https://i.ebayimg.com/images/g/xRQAAOSwotJmRTJl/s-l1600.webp",
                        imageUrl: "${widget.thisPack.thumbnail}",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => customLoader(),
                        errorWidget:
                            (context, url, error) => const Icon(Icons.error),
                      ),
                    )
                    : Icon(Icons.file_copy, size: 70, color: Colors.grey),
          ),
        ),
        Positioned(
          left: 35,
          right: 0,
          top: 25,
          bottom: 0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton.filledTonal(
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                shape: CircleBorder(),
              ),
              tooltip: "Preview".tr,
              icon: Icon(
                size: 50,
                Icons.play_arrow_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                String videoUrl = widget.thisPack.preview ?? "";
                final courseId = widget.thisPack.id!;

                // --- URL Type Checks ---
                final isYouTube =
                    videoUrl.contains("youtube.com") ||
                    videoUrl.contains("youtu.be");
                final isMp4 = RegExp(r"\.mp4(\?|$)").hasMatch(videoUrl);
                final isWebm = RegExp(r"\.webm(\?|$)").hasMatch(videoUrl);
                final isOgg = RegExp(r"\.ogg(\?|$)").hasMatch(videoUrl);
                final isMkv = RegExp(r"\.mkv(\?|$)").hasMatch(videoUrl);
                // -----------------------
                Widget nextPage;

                if (isYouTube) {
                  nextPage = YoutubeVideoPlayerDialog(
                    showControls: false,
                    courseId: courseId,
                    videoUrl: videoUrl,
                  );
                } else if (isMp4 || isOgg || isWebm || isMkv) {
                  nextPage = NetworkVideoPlayerDialog(
                    showControls: false,
                    courseId: courseId,
                    videoUrl: videoUrl,
                  );
                } else {
                  nextPage = Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.videocam_off_rounded,
                              size: 80,
                              color: Colors.white54,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "Video URL Is Not Available.".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                showDialog(
                  context: context,
                  barrierColor: const Color.fromARGB(189, 0, 0, 0),
                  builder: (BuildContext context) {
                    return widget.thisPack.preview != null
                        ? AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          titlePadding: EdgeInsets.zero,
                          insetPadding: EdgeInsets.zero,
                          contentPadding: EdgeInsets.zero,

                          content: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  HexColor('#046181'),
                                  HexColor('#7BC792'),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(3),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: nextPage,
                            ),
                          ),
                        )
                        : AlertDialog(
                          title: Text("No Preview Available".tr),
                          content: Text(
                            "Sorry, There Is No Preview Video Available For This Product."
                                .tr,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("OK".tr),
                            ),
                          ],
                        );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget gradientButtonWrapper({
    required Widget child,
    required double radius,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.brainColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      height: 35,
      child: child,
    );
  }

  Widget _buildCartButton() {
    final isInCart = courseController.cartList.any(
      (item) => item.id == widget.thisPack.id,
    );

    final isLoading = courseController.loadingCartIds.contains(
      widget.thisPack.id,
    );

    return gradientButtonWrapper(
      radius: 10,
      child:
          isLoading
              ? customLoader(color: Colors.white)
              : ElevatedButton(
                onPressed: () => widget.onAddToCartPressed(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isInCart
                          ? Icons.remove_shopping_cart_outlined
                          : Icons.add_shopping_cart_rounded,
                      color: isInCart ? Colors.red : Colors.black,
                    ),
                    SizedBox(width: 5),
                    Text(
                      isInCart ? 'Remove'.tr : "Add".tr,
                      style: TextStyle(
                        color: isInCart ? Colors.red : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildBuyButton() {
    return gradientButtonWrapper(
      radius: 10,
      child: ElevatedButton(
        onPressed: widget.onBuyPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child:  Text(
          'Buy Now'.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
