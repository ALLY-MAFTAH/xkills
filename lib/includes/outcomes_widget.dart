import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import 'section_title.dart';
class OutcomesWidget extends StatelessWidget {
  final List<String> outcomes;

  const OutcomesWidget({super.key, required this.outcomes});

  @override
  Widget build(BuildContext context) {
    if (outcomes.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle("What You Will Learn".tr),
        ...outcomes.map((e) => _checkItem(e)),
      ],
    );
  }
}


Widget _checkItem(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Icon(Icons.check_circle,
            size: 16, color: AppColors.secondaryColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.secondaryColor,
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
}
