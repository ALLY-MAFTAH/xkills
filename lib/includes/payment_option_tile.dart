import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/mno.dart';
import '../theme/app_colors.dart';

Widget paymentOptionTile({
  required bool isSelected,
  required String title,
  required MainAxisAlignment alignment,
  required List<ServiceProvider> options,
}) {
  return Container(
    padding: EdgeInsets.only(right: 10, left: 10, bottom: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color:
          isSelected
              ? Colors.white.withOpacity(0.3)
              : AppColors.secondaryColor.withOpacity(1),
      border:
          isSelected
              ? Border.all(color: AppColors.tertiaryColor, width: 1)
              : Border.all(color: Colors.grey, width: .5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[200],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Radio(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: AppColors.tertiaryColor,
              side: BorderSide(color: Colors.white),
              value: isSelected,
              groupValue: true,
              onChanged: (_) {
                isSelected = !isSelected;
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: alignment,
          children:
                  
              options
                  .map(
                    (option) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 2),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: option.backColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Image.asset(
                          option.logo!,
                          width: (Get.width/4)-26,
                          height: 27,
                          color: option.foreColor,
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    ),
  );
}
