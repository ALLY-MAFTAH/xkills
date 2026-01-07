import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skillsbank/constants/auth_user.dart';
import '/controllers/section_controller.dart';
import '../components/toasts.dart';
import '../constants/app_brand.dart';
import '../constants/endpoints.dart';
import '../enums/enums.dart';
import '../models/course.dart';
import '../models/my_course.dart';
import '../services/http_service.dart';

class CourseController extends GetxController {
  // Course selectedCourse = Course();
  Future<List<Course>>? allCoursesFuture;
  List<Course> _allCourses = [];
  List<Course> get allCourses => _allCourses;

  Future<List<Course>>? topCoursesFuture;
  List<Course> _topCourses = [];
  List<Course> get topCourses => _topCourses;

  Future<List<Course>>? instructorCoursesFuture;
  List<Course> _instructorCourses = [];
  List<Course> get instructorCourses => _instructorCourses;

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
  Set<int> loadingCartIds = {};
  Future<List<Course>>? savedCoursesFuture;
  List<Course> _savedCourses = [];
  List<Course> get savedCourses => _savedCourses;
  Set<int> loadingCourseIds = {};

  Future<List<MyCourse>>? myPacksFuture;
  List<MyCourse> _myPacks = [];
  List<MyCourse> get myPacks => _myPacks;

  Future<List<Course>>? allPacksFuture;
  List<Course> _allPacks = [];
  List<Course> get allPacks => _allPacks;

  Map<int, double> downloadProgress = {}; // courseId : progress 0–1
  Map<int, bool> isDownloading = {}; // courseId : downloading or not
  Map<int, bool> isPaused = {};
  final Map<int, CancelToken> cancelTokens = {};

  //
  //

  Future<Course> getPackById(int id) async {
    return allPacks.firstWhere(
      (pack) => pack.id == id,
      orElse: () => throw Exception('Pack not found.'),
    );
  }

  Future<List<Course>> getAllPacks() async {
    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.GET,
        Endpoints.getAllPacks,
        {},
      );
      if (responseData == null) return allPacks;

      final List fetchedPacks = responseData;

      if (fetchedPacks.isNotEmpty) {
        _allPacks = [];
        for (var pack in fetchedPacks) {
          final calledDataSet = Course.fromJson(pack);

          _allPacks.add(calledDataSet);
        }
      }
      return allPacks;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
    }
    return allPacks;
  }

  Future<List<MyCourse>> getMyPacks() async {
    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.GET,
        Endpoints.getMyPacks,
        {},
      );
      if (responseData == null) return myPacks;

      final List fetchedPacks = responseData;

      if (fetchedPacks.isNotEmpty) {
        _myPacks = [];
        for (var pack in fetchedPacks) {
          final calledDataSet = MyCourse.fromJson(pack);

          _myPacks.add(calledDataSet);
        }
      }
      return myPacks;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
    }
    return myPacks;
  }

  Future<List<Course>> getCoursesByCategory(categoryId) async {
    await getAllCourses();
    final coursesByCategory =
        allCourses.where((course) => course.categoryId == categoryId).toList();
    return coursesByCategory;
  }

  Future<List<Course>> getAllCourses() async {
    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.GET,
        Endpoints.getOtherCourses,
        {},
      );
      if (responseData == null) return allCourses;

      final List fetchedCourses = responseData;

      if (fetchedCourses.isNotEmpty) {
        _allCourses = [];
        for (var course in fetchedCourses) {
          final calledDataSet = Course.fromJson(course);
          _allCourses.add(calledDataSet);
        }
      }
      print(allCourses);
      return allCourses;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
    }
    return allCourses;
  }

  Future<List<Course>> getTopCourses() async {
    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.GET,
        Endpoints.getTopCourses,
        {},
      );
      if (responseData == null) return topCourses;

      final List fetchedCourses = responseData;

      if (fetchedCourses.isNotEmpty) {
        _topCourses = [];
        for (var course in fetchedCourses) {
          final calledDataSet = Course.fromJson(course);
          _topCourses.add(calledDataSet);
        }
      }
      print(topCourses);
      return topCourses;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
    }
    return topCourses;
  }

  Future<List<MyCourse>> getMyCourses() async {
    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.GET,
        Endpoints.getMyCourses,
        {},
      );
      if (responseData == null) return _myCourses;

      final List myFetchedCourses = responseData;
      List<MyCourse> temporaryCourses = [];
      List<Future<void>> durationCalculations = [];

      if (myFetchedCourses.isNotEmpty) {
        for (var myCourseJson in myFetchedCourses) {
          final MyCourse courseModel = MyCourse.fromJson(myCourseJson);

          temporaryCourses.add(courseModel);

          durationCalculations.add(courseModel.calculateTotalDuration());
        }
      }

      await Future.wait(durationCalculations);
      _myCourses = temporaryCourses;
      return _myCourses;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
      return _myCourses;
    }
  }

  Future<List<Course>> getCoursesByInstructor(int id) async {
    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.GET,
        Endpoints.getCoursesByInstructor,
        {"instructor_id": id},
      );
      if (responseData == null) return _instructorCourses;

      final List fetchedInstructorCourses = responseData;
      if (fetchedInstructorCourses.isNotEmpty) {
        _instructorCourses = [];
        for (var course in fetchedInstructorCourses) {
          final calledDataSet = Course.fromJson(course);
          if (calledDataSet.categoryId != 1) {
            _instructorCourses.add(calledDataSet);
          }
        }
      }
      print(instructorCourses);
      return instructorCourses;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
    }
    return instructorCourses;
  }

  Future<List<Course>> getCartList() async {
    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.GET,
        Endpoints.getCartList,
        {},
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
    loadingCartIds.add(courseId);
    update();

    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.GET,
        Endpoints.addOrRemoveCart,
        {"course_id": courseId},
      );

      if (responseData == null) return "";

      String returnedStatus = responseData['status'];

      cartListFuture = getCartList();
      await cartListFuture;
      update();

      return returnedStatus;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
    } finally {
      loadingCartIds.remove(courseId); // ✅ ONLY remove THIS item
      update();
    }

    return "";
  }

  Future<void> storeCourseRate(
    int courseId,
    double rating,
    String review,
  ) async {
    isLoading = true;
    update();

    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.POST,
        Endpoints.storeCourseRate,
        {
          "user_id": Auth().user!.id,
          "course_id": courseId,
          "rating": rating, // now double (e.g. 3.5)
          "review": review,
        },
      );

      if (responseData == null) return;

      bool returnedStatus = responseData['status'];
      String message = responseData['message'];

      if (returnedStatus != true) {
        errorToast(message);
        return;
      } else {
        successToast(message);
      }
    } catch (e) {
      errorToast(e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<String> addOrRemoveSavedCourse(int courseId) async {
    loadingCourseIds.add(courseId);
    update();

    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.GET,
        Endpoints.addOrRemoveSavedCourse,
        {"course_id": courseId},
      );

      if (responseData == null) return "";

      String returnedStatus = responseData['status'];

      savedCoursesFuture = getSavedCourses();
      await savedCoursesFuture;
      update();

      return returnedStatus;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
    } finally {
      loadingCourseIds.remove(courseId); // ✅ ONLY remove THIS item
      update();
    }

    return "";
  }

  Future<List<Course>> getSavedCourses() async {
    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.GET,
        Endpoints.getSavedCourses,
        {},
      );
      if (responseData == null) return savedCourses;

      final List fetchedSavedCourses = responseData;
      _savedCourses = [];
      if (fetchedSavedCourses.isNotEmpty) {
        for (var savedCourse in fetchedSavedCourses) {
          final calledDataSet = Course.fromJson(savedCourse);
          _savedCourses.add(calledDataSet);
        }
      }
      update();
      return savedCourses;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
    } finally {
      isLoading = false;
      update();
    }
    return savedCourses;
  }

  void downloadCourse(int courseId) async {
    isDownloading[courseId] = true;
    downloadProgress[courseId] = 0;
    update();

    if (!await requestStoragePermission()) return;

    final sectionController = Get.put(SectionController());
    await sectionController.getSections(courseId);
    final sections = sectionController.sections;

    final downloadBase = await getDownloadDirectory();
    final appFolder = Directory("$downloadBase/${appName()}");
    if (!appFolder.existsSync()) appFolder.createSync(recursive: true);

    int downloadedFiles = 0;
    int totalFiles = sections.fold(
      0,
      (sum, section) => sum + (section.lessons?.length ?? 0),
    );

    try {
      for (var section in sections) {
        final sectionName = section.title!.replaceAll("/", "_");
        final sectionFolder = Directory("${appFolder.path}/$sectionName");
        if (!sectionFolder.existsSync()) {
          sectionFolder.createSync(recursive: true);
        }

        for (var lesson in section.lessons!) {
          final url = lesson.attachmentUrl;
          if (url == null || url.isEmpty) continue;

          final fileExtension = url.split(".").last;
          final fileName =
              "${lesson.title!.replaceAll('/', '_')}.$fileExtension";
          final savePath = "${sectionFolder.path}/$fileName";

          print("Downloading: $fileName");

          // Use streamed downloadFile function
          await downloadFile(
            url: url,
            savePath: savePath,
            courseId: courseId,
            onProgress: (progressValue) {
              // Overall progress across all lessons
              downloadProgress[courseId] = (downloadedFiles / totalFiles +
                      progressValue / totalFiles)
                  .clamp(0, 1);
              update();
            },
          );

          downloadedFiles++;
        }
      }
    } catch (e) {
      print("Download error: $e");
    } finally {
      isDownloading[courseId] = false;
      isPaused[courseId] = false;
      cancelTokens.remove(courseId);
      update();
    }
  }

  Future<void> downloadFile({
    required String url,
    required String savePath,
    required int courseId,
    void Function(double progress)? onProgress,
  }) async {
    final dio = Dio();
    cancelTokens[courseId] = CancelToken();

    final file = File(savePath);
    final raf = file.openSync(mode: FileMode.write);

    try {
      final response = await dio.get<ResponseBody>(
        url,
        options: Options(
          responseType: ResponseType.stream,
          followRedirects: false,
        ),
        cancelToken: cancelTokens[courseId],
      );

      final total = response.data!.contentLength;
      int received = 0;

      final stream = response.data!.stream;

      await for (var chunk in stream) {
        if (cancelTokens[courseId]?.isCancelled ?? false) {
          throw Exception("Download canceled");
        }

        while (isPaused[courseId] == true) {
          await Future.delayed(Duration(milliseconds: 200));
          if (cancelTokens[courseId]?.isCancelled ?? false) {
            throw Exception("Download canceled");
          }
        }

        raf.writeFromSync(chunk);
        received += chunk.length;

        double progress = total > 0 ? received / total : 0;
        if (onProgress != null) onProgress(progress);
      }

      raf.closeSync();
    } catch (e) {
      raf.closeSync();
      if (e is DioException && CancelToken.isCancel(e)) {
        print("Download canceled: $savePath");
        if (file.existsSync()) file.deleteSync(); // optional
      } else {
        print("Download error: $e");
      }
    } finally {
      cancelTokens.remove(courseId);
    }
  }

  void pauseDownload(int courseId) {
    isPaused[courseId] = true;
    update();
  }

  void resumeDownload(int courseId) {
    isPaused[courseId] = false;
    update();
  }

  void cancelDownload(int courseId) {
    cancelTokens[courseId]?.cancel(); // this stops Dio download immediately
    isDownloading[courseId] = false;
    isPaused[courseId] = false;
    downloadProgress[courseId] = 0;
    update();
  }

  Future<String> getDownloadDirectory() async {
    Directory directory;

    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory =
            await getExternalStorageDirectory() ??
            await getApplicationDocumentsDirectory();
      }
    } else {
      // iOS
      directory = await getApplicationDocumentsDirectory();
    }

    return directory.path;
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }
}
