import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: TextFormField(
              controller: widget.searchController,
              cursorColor: Colors.grey,
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(.1),
                hintText: 'Search here...'.tr,
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: IconButton.filled(
                    onPressed: () {
                      print(widget.searchController.text);
                      widget.onSearch();
                    },
                    icon: Icon(Icons.search, color: Colors.white),
                  ),
                ),
                contentPadding: EdgeInsets.all(15),
                border: OutlineInputBorder(borderSide: BorderSide.none),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// InputDecoration getDecoration(String hintext, VoidCallback onSearchPressed) {
//   return InputDecoration(
//     enabledBorder: OutlineInputBorder(
//       borderRadius: const BorderRadius.all(Radius.circular(10)),
//       borderSide: BorderSide.none,
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: const BorderRadius.all(Radius.circular(10)),
//       borderSide: BorderSide.none,
//     ),
//     border: OutlineInputBorder(
//       borderRadius: const BorderRadius.all(Radius.circular(10)),
//       borderSide: BorderSide.none,
//     ),
//     focusedErrorBorder: const OutlineInputBorder(
//       borderRadius: BorderRadius.all(Radius.circular(10)),
//       borderSide: BorderSide.none,
//     ),
//     errorBorder: const OutlineInputBorder(
//       borderRadius: BorderRadius.all(Radius.circular(10)),
//       borderSide: BorderSide.none,
//     ),
//     filled: true,
//     hintStyle: TextStyle(
//       color: Colors.grey,
//       fontWeight: FontWeight.bold,
//       fontSize: 16,
//     ),
//     hintText: hintext,
//     fillColor:
//         authController.isSubmitting
//             ? Colors.white.withOpacity(.05)
//             : Colors.white.withOpacity(.1),
//     contentPadding: const EdgeInsets.all(15),
//     suffixIcon:
//         hintext == "Password" || hintext == "Confirm Password"
//             ? IconButton(
//               onPressed:
//                   authController.isSubmitting
//                       ? null
//                       : () {
//                         onSearchPressed();
//                       },
//               disabledColor: Colors.grey[700],
//               color: Colors.white,
//               icon:
//                   hintext == "Password"
//                       ? Icon(
//                         authController.passwordObscure
//                             ? Icons.visibility_off_outlined
//                             : Icons.visibility_outlined,
//                       )
//                       : Icon(
//                         authController.confirmPasswordObscure
//                             ? Icons.visibility_off_outlined
//                             : Icons.visibility_outlined,
//                       ),
//             )
//             : null,
//   );
// }
