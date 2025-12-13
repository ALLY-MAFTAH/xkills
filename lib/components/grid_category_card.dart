import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../theme/app_colors.dart';
import 'avatar_widget.dart';
import 'custom_loader.dart';
import 'validations.dart';

class GridCategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String thumbnail;
  final bool isGolden;
  final VoidCallback onTap;

  const GridCategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.thumbnail,
    required this.isGolden,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.all(1.5), // Border thickness
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors:
                isGolden
                    ? [HexColor('#FBAD52'), HexColor('#FEC157')]
                    : [HexColor('#046181'), HexColor('#7BC792')],
          ),
        ),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isGolden ? null : HexColor('#056060'),
                      gradient:
                          isGolden
                              ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  HexColor('#FBAD52'),
                                  HexColor('#FEC157'),
                                ],
                              )
                              : null,
                    ),
                  ),
                ),
      
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    subtitle,
                                    style: TextStyle(
                                      color:
                                          isGolden ? Colors.black : Colors.white,
                                      fontSize: 8,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              title,
                              style: TextStyle(
                                color: isGolden ? Colors.black : Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 77,
                        height: 78,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            thumbnail.isNotEmpty
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: thumbnail,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => customLoader(),
                                    errorWidget:
                                        (context, url, error) =>
                                            const Icon(Icons.error),
                                  ),
                                )
                                : Icon(
                                  Icons.movie_filter,
                                  size: 70,
                                  color: Colors.grey,
                                ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 55, left: 10),
                  child: SizedBox(
                    height: 20,
                    width: 160,
                    child: Stack(
                      children: [
                        for (int i = 0; i < 3 && i < 5; i++)
                          Positioned(
                            left: i * 20,
                            child: AvatarWidget(
                              icon: Icons.piano,
                              iconColor: Colors.orange,
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
        ),
      ),
    );
  }
}
