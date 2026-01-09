import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import 'section_title.dart';

class FaqWidget extends StatelessWidget {
  final List<Map<String, String>> faqs;

  const FaqWidget({super.key, required this.faqs});

  @override
  Widget build(BuildContext context) {
    if (faqs.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle("Frequently Asked Questions".tr),
        ...faqs.map((f) => _faqTile(f)),
      ],
    );
  }
}

Widget _faqTile(Map<String, String> faq) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: AppColors.secondaryColor.withOpacity(1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: ExpansionTile(
      iconColor: AppColors.secondaryColor,
      collapsedIconColor: Colors.white70,
      minTileHeight: 30,
      backgroundColor: AppColors.secondaryColor.withOpacity(.3),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      tilePadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        faq['title'] ?? '',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      children: [
        Container(
          color: Colors.white.withOpacity(.7),
          padding: const EdgeInsets.all(10),
          child: Text(
            faq['description'] ?? '',
            style: TextStyle(color: AppColors.secondaryColor, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}
