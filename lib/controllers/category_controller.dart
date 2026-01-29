import 'package:get/get.dart';
import '../components/toasts.dart';
import '../constants/endpoints.dart';
import '../enums/enums.dart';
import '../models/category.dart';
import '../models/sub_category.dart';
import '../services/http_service.dart';

class CategoryController extends GetxController {
  Future<List<Category>>? categoriesFuture;
  List<Category> _categories = [];
  List<Category> get categories => _categories;

  // SUB
  Future<List<SubCategory>>? subCategoriesFuture;
  List<SubCategory> _subCategories = [];
  List<SubCategory> get subCategories => _subCategories;

  Future<List<Category>> getCategories() async {
    try {
      final responseData = await HttpService.sendHttpRequest(
        "GET CATEGORIES ENDPOINT :::",

        RequestType.GET,
        Endpoints.getCategories,
        {},
      );
      if (responseData == null) return categories;

      final List fetchedCategories = responseData;

      _categories = [];
      if (fetchedCategories.isNotEmpty) {
        _subCategories = [];
        for (var category in fetchedCategories) {
          final calledDataSet = Category.fromJson(category);
          _categories.add(calledDataSet);
        }
      }

      return categories;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
    }
    return categories;
  }

  Future<List<SubCategory>> getSubCategories() async {
    try {
      final responseData = await HttpService.sendHttpRequest(
        "GET SUB CATEGORIES ENDPOINT :::",

        RequestType.GET,
        Endpoints.getSubCategories,
        {},
      );
      if (responseData == null) return subCategories;

      final List fetchedSubCategories = responseData;

      _subCategories = [];
      if (fetchedSubCategories.isNotEmpty) {
        for (var subCategory in fetchedSubCategories) {
          final calledDataSet = SubCategory.fromJson(subCategory);
          _subCategories.add(calledDataSet);
        }
      }
      return subCategories;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
    }
    return subCategories;
  }
}
