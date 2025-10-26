class Lesson {
  final int? id;
  final String? title;
  final String? duration;
  final int? courseId;
  final int? sectionId;
  final String? videoType;
  final String? videoUrl;
  final String? lessonType;
  final bool? isFree;
  final String? attachment;
  final String? attachmentUrl;
  final String? attachmentType;
  final String? summary;
  final bool? isCompleted;
  final bool? userValidity;

  Lesson({
    this.id,
    this.title,
    this.duration,
    this.courseId,
    this.sectionId,
    this.videoType,
    this.videoUrl,
    this.lessonType,
    this.isFree,
    this.attachment,
    this.attachmentUrl,
    this.attachmentType,
    this.summary,
    this.isCompleted,
    this.userValidity,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as int,
      title: json['title'] as String,
      // The duration is a string like "00:00"
      duration: json['duration'] as String,
      courseId: json['course_id'] as int,
      sectionId: json['section_id'] as int,
      videoType: json['video_type'] as String,
      videoUrl: json['video_url'] as String,
      lessonType: json['lesson_type'] as String,
      // JSON values like null are mapped to nullable types (bool?)
      isFree: json['is_free'] as bool?,
      attachment: json['attachment'] as String?,
      attachmentUrl: json['attachment_url'] as String?,
      attachmentType: json['attachment_type'] as String?,
      summary: json['summary'] as String?,
      isCompleted: json['is_completed'] as bool?,
      userValidity: json['user_validity'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'course_id': courseId,
      'section_id': sectionId,
      'video_type': videoType,
      'video_url': videoUrl,
      'lesson_type': lessonType,
      'is_free': isFree,
      'attachment': attachment,
      'attachment_url': attachmentUrl,
      'attachment_type': attachmentType,
      'summary': summary,
      'is_completed': isCompleted,
      'user_validity': userValidity,
    };
  }
}
