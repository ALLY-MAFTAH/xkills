import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../components/toasts.dart';
import '../constants/app_brand.dart';
import '../constants/endpoints.dart';
import '../enums/enums.dart';
import '../models/section.dart';
import '../services/http_service.dart';

class SectionController extends GetxController {
  Section selectedSection = Section();

  Future<List<Section>>? sectionsFuture;
  List<Section> _sections = [];
  List<Section> get sections => _sections;
  final List<DropdownMenuItem<String>> _sectionList = [];
  List<DropdownMenuItem<String>> get sectionsDropdown => _sectionList;
  Map<int, bool> isDownloading = {}; // lessonId -> bool
  Map<int, double> downloadProgress = {}; // lessonId -> double
  Map<int, bool> isPaused = {}; // lessonId -> bool
  Map<int, CancelToken> cancelTokens = {}; // lessonId -> CancelToken

  Future<List<Section>> getSections(int courseId) async {
    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.GET,
        Endpoints.getSections,
        {"course_id": courseId},
        false,
      );
      if (responseData == null) return sections;

      final List fetchedSections = responseData;
      if (fetchedSections.isNotEmpty) {
        _sections = [];
        for (var section in fetchedSections) {
          final calledDataSet = Section.fromJson(section);

          _sections.add(calledDataSet);
          print(_sections);
        }
      }
      return sections;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
    }
    return sections;
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<String> getDownloadDirectory() async {
    Directory? directory;

    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    } else {
      directory = await getDownloadsDirectory();
    }

    return directory!.path;
  }

  void downloadLessonVideo({
    required int lessonId,
    required String courseTitle,
    required String sectionName,
    required String lessonTitle,
    required String url,
  }) async {
    isDownloading[lessonId] = true;
    downloadProgress[lessonId] = 0;
    isPaused[lessonId] = false;
    cancelTokens[lessonId] = CancelToken();
    update();

    // -----------------------------------
    // 1. BLOCK YOUTUBE DOWNLOADS
    // -----------------------------------
    if (url.contains("youtube.com") || url.contains("youtu.be")) {
      print("⚠️ Cannot download YouTube video: $url");
      errorToast("This video is hosted on YouTube and cannot be downloaded.");
      isDownloading[lessonId] = false;
      update();
      return;
    }

    if (!await requestStoragePermission()) {
      print("Storage permission denied");
      return;
    }

    final dio = Dio();

    try {
      final downloadBase = await getDownloadDirectory();
      final appFolder = Directory("$downloadBase/${appName()}");
      if (!appFolder.existsSync()) appFolder.createSync(recursive: true);

      // Clean folder names
      final sanitizedCourseTitle = courseTitle.replaceAll(
        RegExp(r'[\/\\:*?"<>|]'),
        "_",
      );
      final sanitizedSection = sectionName.replaceAll(
        RegExp(r'[\/\\:*?"<>|]'),
        "_",
      );

      final sectionFolder = Directory(
        "${appFolder.path}/$sanitizedCourseTitle/$sanitizedSection",
      );

      if (!sectionFolder.existsSync())
        sectionFolder.createSync(recursive: true);

      // -----------------------------------
      // 2. FIX FILENAME + EXTENSION
      // -----------------------------------
      final sanitizedLesson = lessonTitle.replaceAll(
        RegExp(r'[\/\\:*?"<>|]'),
        "_",
      );

      // Detect real video extension
      final validExtensions = ["mp4", "mov", "mkv", "avi"];

      String fileExtension = url.split("?").first.split(".").last.toLowerCase();

      // If extension is INVALID → force mp4
      if (!validExtensions.contains(fileExtension)) {
        fileExtension = "mp4";
      }

      final savePath = "${sectionFolder.path}/$sanitizedLesson.$fileExtension";

      print("Downloading $lessonTitle -> $savePath");

      await dio.download(
        url,
        savePath,
        cancelToken: cancelTokens[lessonId],
        onReceiveProgress: (received, total) {
          if (total > 0) {
            downloadProgress[lessonId] = (received / total).clamp(0.0, 1.0);
            update();
          }
        },
      );
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        print("Download canceled for lesson $lessonId");
      } else {
        print("Download error for lesson $lessonId: $e");
        errorToast("Download failed.");
      }
    } finally {
      isDownloading[lessonId] = false;
      isPaused[lessonId] = false;
      cancelTokens.remove(lessonId);
      update();
    }
  }

  void pauseLesson(int lessonId) {
    isPaused[lessonId] = true;
    update();
  }

  void resumeLesson(int lessonId) {
    isPaused[lessonId] = false;
    update();
  }

  void cancelLesson(int lessonId) {
    cancelTokens[lessonId]?.cancel();
    isDownloading[lessonId] = false;
    isPaused[lessonId] = false;
    downloadProgress[lessonId] = 0;
    cancelTokens.remove(lessonId);
    update();
  }
}
