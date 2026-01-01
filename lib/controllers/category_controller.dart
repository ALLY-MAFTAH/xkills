import 'package:get/get.dart';
import '../components/toasts.dart';
import '../constants/endpoints.dart';
import '../enums/enums.dart';
import '../models/category.dart';
import '../models/sub_category.dart';
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

  // SUB
  Future<List<SubCategory>>? subCategoriesFuture;
  List<SubCategory> _subCategories = [];
  List<SubCategory> get subCategories => _subCategories;

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
        RequestType.GET,
        Endpoints.getSubCategories,
        {},
        false,
      );
      if (responseData == null) return subCategories;

      final List fetchedSubCategories = responseData;

      if (fetchedSubCategories.isNotEmpty) {
        _subCategories = [];
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
