import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'avatar_widget.dart';
import 'validations.dart';

class GridCategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isGolden;

  const GridCategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isGolden,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      margin: const EdgeInsets.all(0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      // const Color.fromARGB(255, 6, 98, 100),
                      AppColors.secondaryColor,
                      AppColors.primaryColor,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.35),
                      Colors.white.withOpacity(0.10),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.04, 0.08],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white.withOpacity(0.3), Colors.transparent],
                    stops: const [0.0, 0.3],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      if (isGolden)
                        Text(
                          '👑',
                          style: TextStyle(
                            fontSize: 18,
                            height: 1,
                            color: Colors.amber[700],
                          ),
                        ),
                    ],
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 70, left: 10),
              child: SizedBox(
              height: 20,
              width: 160,
              child: Stack(
                children: [
                  for (int i = 0; i < 3 && i < 5; i++)
                    Positioned(
                      left: i * 14.0,
                      child: AvatarWidget(
                        photoUrl: "assets/images/teacher02.png",
                        index: i,
                        initial: getInitial("Ally Maftah"),
                        radius: 8,
                      ),
                    ),
                  if (3 > 5)
                    Positioned(
                      left: 6 * 14.0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.grey[300],
                        child: Text(
                          '+${3 - 5}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color.fromARGB(255, 71, 71, 71),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
