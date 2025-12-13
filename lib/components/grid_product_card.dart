import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../controllers/course_controller.dart';
import '/models/course.dart';
import '../theme/app_colors.dart';
import 'custom_loader.dart';
import 'from_network.dart';
import 'youtube_player_dialog.dart';

class GridProductCard extends StatefulWidget {
  final Course thisProduct;
  final VoidCallback onBuyPressed;
  final VoidCallback onAddToCartPressed;
  final VoidCallback onDownloadPressed;
  const GridProductCard({
    super.key,
    required this.thisProduct,
    required this.onBuyPressed,
    required this.onAddToCartPressed,
    required this.onDownloadPressed,
  });

  @override
  State<GridProductCard> createState() => _GridProductCardState();
}

class _GridProductCardState extends State<GridProductCard> {
  final courseController = Get.put(CourseController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Container(
            padding: EdgeInsets.all(1.5), // Border thickness
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [HexColor('#046181'), HexColor('#7BC792')],
              ),
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: HexColor('#056060'), // ✅ Your original background color
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.thisProduct.title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.thisProduct.price!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 20),
                    GetBuilder<CourseController>(
                      builder: (courseController) {
                        bool hasEnrollered = courseController.myCourses.any(
                          (course) => course.id == widget.thisProduct.id,
                        );
                        if (!hasEnrollered) {
                          final isDownloading =
                              courseController.isDownloading[widget
                                  .thisProduct
                                  .id] ??
                              false;
                          final progress =
                              courseController.downloadProgress[widget
                                  .thisProduct
                                  .id] ??
                              0;
                          final isPaused =
                              courseController.isPaused[widget
                                  .thisProduct
                                  .id] ??
                              false;

                          return gradientButtonWrapper(
                            radius: 10,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!isDownloading) {
                                  courseController.downloadCourse(
                                    widget.thisProduct.id!,
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
                                                        minHeight: 14,
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
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10),

                                          // PAUSE / RESUME BUTTON
                                          IconButton(
                                            onPressed: () {
                                              isPaused
                                                  ? courseController
                                                      .resumeDownload(
                                                        widget.thisProduct.id!,
                                                      )
                                                  : courseController
                                                      .pauseDownload(
                                                        widget.thisProduct.id!,
                                                      );
                                            },
                                            icon: Icon(
                                              isPaused
                                                  ? Icons.play_arrow_rounded
                                                  : Icons.pause_rounded,
                                              color: Colors.white,
                                            ),
                                          ),

                                          // CANCEL BUTTON
                                          IconButton(
                                            onPressed: () {
                                              courseController.cancelDownload(
                                                widget.thisProduct.id!,
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
                                        children: [
                                          Icon(
                                            Icons.download_rounded,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Download",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
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
                              final isSmall = constraints.maxWidth < 320;

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
                                        width: 150,
                                        child: _buildBuyButton(),
                                      ),
                                      SizedBox(
                                        width: 150,
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
          right: 20,
          top: 0,
          child: Container(
            height: Get.height / 5.5,
            width: Get.width / 3.6,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(color: Colors.transparent),
            child:
                widget.thisProduct.thumbnail!.isNotEmpty
                    ? ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: CachedNetworkImage(
                        // imageUrl:  "https://i.ebayimg.com/images/g/xRQAAOSwotJmRTJl/s-l1600.webp",
                        imageUrl: "${widget.thisProduct.thumbnail}",
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
          left: 0,
          right: 0,
          top: 40,
          bottom: 0,
          child: Align(
            alignment: Alignment.center,
            child: IconButton.filledTonal(
              onPressed: () {
                String videoUrl = widget.thisProduct.preview ?? "";
                final courseId = widget.thisProduct.id!;

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
                  nextPage = YoutubePlayerDialog(
                    courseId: courseId,
                    videoUrl: videoUrl,
                  );
                } else if (isMp4 || isOgg || isWebm || isMkv) {
                  nextPage = PlayVideoFromNetwork(
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
                            const Text(
                              "Video URL is not available.",
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
                    return widget.thisProduct.preview != null
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
                          title: Text("No Preview Available"),
                          content: Text(
                            "Sorry, there is no preview video available for this product.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("OK"),
                            ),
                          ],
                        );
                  },
                );
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                shape: CircleBorder(),
              ),
              tooltip: "Preview",
              icon: Icon(
                size: 35,
                Icons.play_arrow_rounded,
                color: AppColors.tertiaryColor,
              ),
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
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [HexColor('#046181'), HexColor('#7BC792')],
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      height: 35,
      child: child,
    );
  }

  Widget _buildCartButton() {
    final isInCart = courseController.cartList.any(
      (item) => item.id == widget.thisProduct.id,
    );

    final isLoading = courseController.loadingCartIds.contains(
      widget.thisProduct.id,
    );

    return gradientButtonWrapper(
      radius: 10,
      child:
          isLoading
              ? customLoader(color: Colors.white)
              : ElevatedButton(
                onPressed: () => widget.onAddToCartPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isInCart
                          ? Icons.remove_shopping_cart_outlined
                          : Icons.add_shopping_cart_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      isInCart ? 'Remove' : "Add",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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
        child: const Text(
          'Buy Now',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
