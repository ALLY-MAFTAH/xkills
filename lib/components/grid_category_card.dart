import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'custom_loader.dart';

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
      child: LiquidGlassLayer(
        settings: const LiquidGlassSettings(
          thickness: 20,
          blur: 10,
          glassColor: Colors.grey,
          lightAngle: 0.5 * pi,
          chromaticAberration: 1,
        ),
        child: LiquidGlass(
          shape: LiquidRoundedSuperellipse(borderRadius: 10),
          child: Padding(
            padding: const EdgeInsets.all(.7),
            child: Stack(
              children: [
                Stack(
                  fit: StackFit.expand, // 👈 fills available space
                  children: [
                    if (thumbnail.isNotEmpty)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: thumbnail,
                            fit: BoxFit.cover, // 👈 fills entire area
                            placeholder: (context, url) => customLoader(),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error),
                          ),
                        ),
                      )
                    else
                      const Center(
                        child: Icon(
                          Icons.movie_filter,
                          size: 70,
                          color: Colors.grey,
                        ),
                      ),

                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(10 ),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            shadows: const [
                              Shadow(
                                blurRadius: 6,
                                color: Colors.black54,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
