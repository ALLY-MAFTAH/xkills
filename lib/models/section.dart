import 'lesson.dart';

class Section {
  final int? id;
  final int? userId;
  final int? courseId;
  final String? title;
  final int? sort;
  final String? createdAt;
  final String? updatedAt;
  final List<Lesson>? lessons;
  final String? totalDuration;
  final int? lessonCounterStarts;
  final int? lessonCounterEnds;
  final int? completedLessonNumber;
  final bool? userValidity;

  Section({
    this.id,
    this.userId,
    this.courseId,
    this.title,
    this.sort,
    this.createdAt,
    this.updatedAt,
    this.lessons,
    this.totalDuration,
    this.lessonCounterStarts,
    this.lessonCounterEnds,
    this.completedLessonNumber,
    this.userValidity,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    // Safely parse the nested list of lessons
    var lessonsList = json['lessons'] as List<dynamic>?;
    List<Lesson> parsedLessons =
        lessonsList != null
            ? lessonsList
                .map((i) => Lesson.fromJson(i as Map<String, dynamic>))
                .toList()
            : [];

    return Section(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      courseId: json['course_id'] as int,
      title: json['title'] as String,
      sort: json['sort'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      lessons: parsedLessons,
      // The total duration is a string like "00:00:00"
      totalDuration: json['total_duration'] as String,
      lessonCounterStarts: json['lesson_counter_starts'] as int,
      lessonCounterEnds: json['lesson_counter_ends'] as int,
      completedLessonNumber: json['completed_lesson_number'] as int,
      userValidity: json['user_validity'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'course_id': courseId,
      'title': title,
      'sort': sort,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'lessons': lessons!.map((x) => x.toJson()).toList(),
      'total_duration': totalDuration,
      'lesson_counter_starts': lessonCounterStarts,
      'lesson_counter_ends': lessonCounterEnds,
      'completed_lesson_number': completedLessonNumber,
      'user_validity': userValidity,
    };
  }
}
