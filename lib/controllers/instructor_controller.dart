import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/toasts.dart';
import '../constants/endpoints.dart';
import '../enums/enums.dart';
import '../models/instructor.dart';
import '../services/http_service.dart';

class InstructorController extends GetxController {
  var selectedInstructor = 0.obs;

  void changeInstructorIndex(int index) {
    selectedInstructor.value = index;
  }

  Future<List<Instructor>>? instructorsFuture;
  List<Instructor> _instructors = [];
  List<Instructor> get instructors => _instructors;
  final List<DropdownMenuItem<String>> _instructorList = [];
  List<DropdownMenuItem<String>> get instructorsDropdown => _instructorList;

Future<Instructor> getInstructorById(int id) async {
  return instructors.firstWhere(
    (instructor) => instructor.id == id,
    orElse: () => throw Exception('Instructor not found.'),
  );
}

  Future<List<Instructor>> getInstructors() async {
    try {
      final responseData = await HttpService.sendHttpRequest(
        RequestType.GET,
        Endpoints.getInstructors,
        {},
        false,
      );
      if (responseData == null) return instructors;

      final List fetchedInstructors = responseData['data'];
      if (fetchedInstructors.isNotEmpty) {
        _instructors = [];
        for (var instructor in fetchedInstructors) {
          final calledDataSet = Instructor.fromJson(instructor);
          _instructors.add(calledDataSet);
        }
      }
      print(instructors);
      return instructors;
    } catch (e) {
      print(e.toString());
      errorToast(e.toString());
    }
    return instructors;
  }
}
