import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

Widget sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.secondaryColor,
                overflow: TextOverflow.ellipsis
              ),
            ),
          ],
        ),
        Divider(
          color: AppColors.secondaryColor.withOpacity(.1),
          thickness: 1,
        ),
      ],
    ),
  );
}
