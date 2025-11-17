import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AvatarWidget extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String? initial;
  final double radius; // Made non-nullable, using 25 as default
  final int index;

  const AvatarWidget({
    super.key,
    this.icon,
    this.iconColor,
    this.initial,
    this.radius = 25, // Default is 25
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Determine Background Color based on index
    final colors = [
      AppColors.primaryColor,
      AppColors.secondaryColor,
      AppColors.tertiaryColor.withOpacity(.5),
    ];
    final bgColor = colors[index % colors.length];

    // 2. Determine Content (Icon or Initial Text)
    Widget content;
    double contentSize = radius * 0.8; // Icon size or text font size

    if (icon != null) {
      // Case 1: Display Icon
      content = Icon(
        icon,
        size: contentSize,
        color: iconColor ?? Colors.white,
      );
    } else {
      // Case 2: Display Initial Text
      content = Text(
        initial ?? "",
        style: TextStyle(
          fontSize: contentSize * 0.8, // Slightly smaller font than icon size
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    // 3. Build the final CircleAvatar
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      // Removed redundant border property from the outer Container
      child: CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        child: content,
      ),
    );
  }
}