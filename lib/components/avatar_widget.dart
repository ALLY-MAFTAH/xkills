import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/endpoints.dart';
import '../../theme/app_colors.dart';

class AvatarWidget extends StatelessWidget {
  final String? photoUrl;
  final String? initial;
  final double? radius;
  final int index;

  const AvatarWidget({
    super.key,
    this.photoUrl,
    this.initial,
    this.radius = 25,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.primaryColor,
      AppColors.secondaryColor,
      AppColors.tertiaryColor,
    ];
    final bgColor = colors[index % colors.length];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: bgColor,
        ),
      ),
      child: CachedNetworkImage(
        imageUrl: photoUrl == null ? "" : photoUrl!,
        imageBuilder:
            (context, imageProvider) => CircleAvatar(
              radius: radius,
              backgroundImage: imageProvider,
              backgroundColor: photoUrl == null ? bgColor : null,
            ),
        placeholder:
            (context, url) => Center(
              child: SizedBox(
                width: 2 * (radius ?? 25),
                height: 2 * (radius ?? 25),
                child: CupertinoActivityIndicator(
                  radius: 3,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
        errorWidget:
            (context, url, error) => CircleAvatar(
              radius: radius,
              backgroundColor: bgColor,
              child: Text(
                initial ?? "",
                style: TextStyle(fontSize: radius!-0, color: Colors.white),
              ),
            ),
      ),
    );
  }
}
