import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xkills/theme/app_colors.dart';
import '/includes/section_title.dart';

class RequirementsWidget extends StatelessWidget {
  final List<String> requirements;

  const RequirementsWidget({super.key, required this.requirements});

  @override
  Widget build(BuildContext context) {
    if (requirements.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle("Requirements For This Course".tr),
        ...requirements.map((e) => _bulletItem(e)),
      ],
    );
  }
}

Widget _bulletItem(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.donut_small,
          size: 16,
          color: AppColors.secondaryColor,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: AppColors.secondaryColor, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}
