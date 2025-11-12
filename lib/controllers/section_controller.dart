import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/toasts.dart';
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

  Future<void> updateSectionDropdownList() async {
    if (sections.isNotEmpty) {
      _sectionList.clear();
      _sectionList.add(
        DropdownMenuItem(
          value: "0",
          enabled: false,
          child: Text(
            "select_section".tr,
            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey),
            softWrap: true,
          ),
        ),
      );
      for (var section in sections) {
        _sectionList.add(
          DropdownMenuItem(
            value: section.id.toString(),
            child: Text(
              section.title.toString(),
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
      _sectionList.clear();
      _sectionList.add(
        DropdownMenuItem(
          value: 0.toString(),
          child: Text(
            "no_section".tr,
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
      );
    }
  }
}
