import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/toasts.dart';
import '../constants/endpoints.dart';
import '../enums/enums.dart';
import '../models/category.dart';
import '../services/http_service.dart';

class CategoryController extends GetxController {
  Category? selectedCategory;

  void selectCategory(int id) {
    if (id == 0) {
      selectedCategory = null;
    } else {
      selectedCategory = categories.firstWhere((category) => category.id == id);
    }
    update();
  }

  Future<List<Category>>? categoriesFuture;
  List<Category> _categories = [];
  List<Category> get categories => _categories;
  final List<DropdownMenuItem<String>> _categoryList = [];
  List<DropdownMenuItem<String>> get categoriesDropdown => _categoryList;

  Future<List<Category>> getCategories() async {
    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.GET,
        Endpoints.getCategories,
        {},
        false,
      );
      if (responseData == null) return categories;

      final List fetchedCategories = responseData;
      if (fetchedCategories.isNotEmpty) {
        _categories = [];
        for (var category in fetchedCategories) {
          final calledDataSet = Category.fromJson(category);
          if (calledDataSet.id != 1) {
            _categories.add(calledDataSet);
          }
        }
      }
      await updateCategoryDropdownList();

      print(categories);
      return categories;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
    }
    await updateCategoryDropdownList();
    return categories;
  }

  Future<void> updateCategoryDropdownList() async {
    if (categories.isNotEmpty) {
      _categoryList.clear();
      _categoryList.add(
        DropdownMenuItem(
          value: "0",
          enabled: false,
          child: Text(
            "select_category".tr,
            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey),
            softWrap: true,
          ),
        ),
      );
      for (var category in categories) {
        _categoryList.add(
          DropdownMenuItem(
            value: category.id.toString(),
            child: Text(
              category.title.toString(),
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
        );
      }
    } else {
      _categoryList.clear();
      _categoryList.add(
        DropdownMenuItem(
          value: 0.toString(),
          child: Text(
            "no_category".tr,
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
      );
    }
  }
}
