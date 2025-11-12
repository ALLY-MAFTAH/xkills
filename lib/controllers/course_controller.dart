import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/toasts.dart';
import '../constants/endpoints.dart';
import '../enums/enums.dart';
import '../models/course.dart';
import '../models/my_course.dart';
import '../services/http_service.dart';

class CourseController extends GetxController {
  Course selectedCourse = Course();
  Future<List<Course>>? coursesFuture;
  List<Course> _courses = [];
  List<Course> get courses => _courses;

  MyCourse mySelectedCourse = MyCourse();
  Future<List<MyCourse>>? myCoursesFuture;
  List<MyCourse> _myCourses = [];
  List<MyCourse> get myCourses => _myCourses;

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

  Future<List<MyCourse>> getMyCourses() async {
    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.GET,
        Endpoints.getMyCourses,
        {},
        false,
      );
      if (responseData == null) return _myCourses;

      final List myFetchedCourses = responseData;

      // ⭐️ 1. List to hold the MyCourse objects
      List<MyCourse> temporaryCourses = [];

      // ⭐️ 2. List to hold all the duration calculation Futures
      List<Future<void>> durationCalculations = [];

      if (myFetchedCourses.isNotEmpty) {
        for (var myCourseJson in myFetchedCourses) {
          // A. Synchronously create the model object
          final MyCourse courseModel = MyCourse.fromJson(myCourseJson);
          temporaryCourses.add(courseModel);

          // B. Start the ASYNCHRONOUS duration calculation
          // and add the Future to the list.
          durationCalculations.add(courseModel.calculateTotalDuration());
        }
      }

      // ⭐️ 3. CRITICAL: Wait for ALL duration calculations to complete
      await Future.wait(durationCalculations);

      // 4. Update the controller state now that all data is ready
      _myCourses = temporaryCourses;

      print("Fetched ${myCourses.length} my courses");
      return _myCourses;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
      return _myCourses;
    }
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

  Future<bool> freeCourseEnroll(int courseId) async {
    print("Reached here");
    isLoading = true;
    update();
    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.GET,
        "${Endpoints.freeCourseEnroll}/$courseId",
        {},
        false,
      );
      if (responseData == null) return false;
      print(responseData);
      print("IS CHECKING");
      if (responseData == []) {
        print("IS EMPTY");
        return false;
      }
      bool status = responseData['status'];
      String message = responseData['message'];

      print(status);
      if (status) {
        successToast(message);
      }
      myCoursesFuture = getMyCourses();
      update();
      return status;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
    } finally {
      isLoading = false;
      update();
    }
    return false;
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
