import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '/theme/app_colors.dart';

class CustomSearch extends StatefulWidget {
  final TextEditingController searchController;
  final VoidCallback onSearch;
  const CustomSearch({
    super.key,
    required this.searchController,
    required this.onSearch,
  });

  @override
  State<CustomSearch> createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: RepaintBoundary(
              child: LiquidGlassLayer(
                settings: const LiquidGlassSettings(
                  thickness: 10,
                  blur: 1,
                  glassColor: Color.fromARGB(16, 255, 255, 255),
                ),
                child: LiquidGlass(
                  shape: LiquidRoundedSuperellipse(borderRadius: 50),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: widget.searchController,
                      cursorColor: Colors.grey,
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                      decoration: InputDecoration(
                        filled: false,
                        fillColor: Colors.transparent,
                        hintText: 'Search here...'.tr,
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 10,
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: IconButton(
                            onPressed: () {
                              print(widget.searchController.text);
                              widget.onSearch();
                            },
                            icon: Icon(
                              Icons.search,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(17),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '/theme/app_colors.dart';

// class CustomSearch extends StatefulWidget {
//   final TextEditingController searchController;
//   final VoidCallback onSearch;
//   const CustomSearch({
//     super.key,
//     required this.searchController,
//     required this.onSearch,
//   });

//   @override
//   State<CustomSearch> createState() => _CustomSearchState();
// }

// class _CustomSearchState extends State<CustomSearch> {
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: Stack(
//         children: [
//           Container(
//             height: 45,
//             padding: const EdgeInsets.symmetric(vertical: 0),
//             child: TextFormField(
//               controller: widget.searchController,
//               cursorColor: Colors.grey,
//               style: TextStyle(
//                 color: Colors.white,
//                 decoration: TextDecoration.none,
//               ),
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: Colors.white.withOpacity(.1),
//                 hintText: 'Search here...'.tr,
//                 hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
//                 suffixIcon: Padding(
//                   padding: const EdgeInsets.all(4.0),
//                   child: IconButton(
//                     onPressed: () {
//                       print(widget.searchController.text);
//                       widget.onSearch();
//                     },
//                     icon: Icon(Icons.search, size: 18, color: Colors.white),
//                   ),
//                 ),
//                 contentPadding: EdgeInsets.all(15),
//                 border: OutlineInputBorder(borderSide: BorderSide.none),
//                 enabledBorder: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
