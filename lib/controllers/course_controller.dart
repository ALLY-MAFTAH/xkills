import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/toasts.dart';
import '../constants/endpoints.dart';
import '../enums/enums.dart';
import '../models/course.dart';
import '../services/http_service.dart';

class CourseController extends GetxController {
  Course selectedCourse = Course();
  Future<List<Course>>? coursesFuture;
  List<Course> _courses = [];
  List<Course> get courses => _courses;
  final List<DropdownMenuItem<String>> _courseList = [];
  List<DropdownMenuItem<String>> get coursesDropdown => _courseList;

  Duration cartTimeout = Duration(hours: 1);
  Future<List<Course>>? cartListFuture;
  List<Course> _cartList = [];
  List<Course> get cartList => _cartList;
  bool isLoading = false;

  Future<List<Course>> getCourses() async {
    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.GET,
        Endpoints.getCourses,
        {},
        false,
      );
      if (responseData == null) return courses;

      final List fetchedCourses = responseData;
      if (fetchedCourses.isNotEmpty) {
        _courses = [];
        for (var course in fetchedCourses) {
          final calledDataSet = Course.fromJson(course);
          _courses.add(calledDataSet);
        }
      }
      await updateCourseDropdownList();

      print(courses);
      return courses;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
    }
    await updateCourseDropdownList();
    return courses;
  }

  Future<List<Course>> getCartList() async {
    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.GET,
        Endpoints.getCartList,
        {},
        false,
      );
      if (responseData == null) return cartList;

      final List fetchedCarts = responseData;
      _cartList = [];
      if (fetchedCarts.isNotEmpty) {
        for (var cart in fetchedCarts) {
          final calledDataSet = Course.fromJson(cart);
          _cartList.add(calledDataSet);
        }
      }
      print(cartList);
      update();
      return cartList;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
    } finally {
      isLoading = false;
      update();
    }
    return cartList;
  }

  Future<String> addOrRemoveCart(int courseId) async {
    print("Reached here");
    isLoading = true;
    update();
    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.GET,
        Endpoints.addOrRemoveCart,
        {"course_id": courseId},
        false,
      );
      if (responseData == null) return "";
      print(responseData);
      String returnedStatus = responseData['status'];

      print(returnedStatus);
      cartListFuture = getCartList();
      update();
      return returnedStatus;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
    } finally {
      update();
    }
    return "";
  }

  Future<void> updateCourseDropdownList() async {
    if (courses.isNotEmpty) {
      _courseList.clear();
      _courseList.add(
        DropdownMenuItem(
          value: "0",
          enabled: false,
          child: Text(
            "select_course".tr,
            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey),
            softWrap: true,
          ),
        ),
      );
      for (var course in courses) {
        _courseList.add(
          DropdownMenuItem(
            value: course.id.toString(),
            child: Text(
              course.title.toString(),
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
      _courseList.clear();
      _courseList.add(
        DropdownMenuItem(
          value: 0.toString(),
          child: Text(
            "no_course".tr,
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
      );
    }
  }
}
