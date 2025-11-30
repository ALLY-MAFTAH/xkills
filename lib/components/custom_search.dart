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
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.secondaryColor],
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
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white.withOpacity(0.4), Colors.transparent],
                  stops: [0.0, 0.20],
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
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.05),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.12, 1.0],
                ),
              ),
            ),
          ),
          TextFormField(
            controller: widget.searchController,
            cursorColor: Colors.grey,
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              hintText: 'Search here...'.tr,
              hintStyle: TextStyle(color: Colors.grey[400]),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(2.0),
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
        ],
      ),
    );
  }
}
