import 'package:get/get.dart';
import '/controllers/section_controller.dart';
import '../utils/time_conversion.dart';
import 'section.dart';

class MyCourse {
  int? id;
  String? title;
  String? slug;
  String? shortDescription;
  int? userId;
  int? categoryId;
  String? courseType;
  String? status;
  String? level;
  String? language;
  bool? isPaid; // Converted from 1/0
  bool? isBest; // Converted from 1/0
  String? price; // String: "$ 3"
  double? priceForPayment; // Can be int or double
  num? discountedPrice; // Can be int or double
  bool? discountFlag; // Converted from 1/0
  bool? enableDripContent; // Converted from 1/0
  String? dripContentSettings;
  String? metaKeywords;
  String? metaDescription;
  String? thumbnail;
  String? banner;
  String? preview;
  String? description;
  List<String>? requirements;
  List<String>? outcomes;
  List<Map<String, String>>? faqs;

  String? instructorIds;
  double? averageRating; // Converted from String "0.0"
  String? createdAt;
  String? updatedAt;
  String? expiryPeriod;
  List<String>? instructors;
  num? priceCart;
  String? instructorName;
  String? instructorProfile;
  String? instructorImage;
  int? totalEnrollment;
  String? shareableLink;
  int? totalReviews;

  int? totalNumberOfCompletedLessons;
  int? totalNumberOfLessons;
  num? completion;
  String? totalDuration;

  MyCourse({
    this.id,
    this.title,
    this.slug,
    this.shortDescription,
    this.userId,
    this.categoryId,
    this.courseType,
    this.status,
    this.level,
    this.language,
    this.isPaid,
    this.isBest,
    this.price,
    this.priceForPayment,
    this.discountedPrice,
    this.discountFlag,
    this.enableDripContent,
    this.dripContentSettings,
    this.metaKeywords,
    this.metaDescription,
    this.thumbnail,
    this.banner,
    this.preview,
    this.description,
    this.requirements,
    this.outcomes,
    this.faqs,
    this.instructorIds,
    this.averageRating,
    this.createdAt,
    this.updatedAt,
    this.expiryPeriod,
    this.instructors,
    this.priceCart,
    this.instructorName,
    this.instructorProfile,
    this.instructorImage,
    this.totalEnrollment,
    this.shareableLink,
    this.totalReviews,
    this.totalNumberOfCompletedLessons,
    this.totalNumberOfLessons,
    this.completion,
    this.totalDuration,
  });

  factory MyCourse.fromJson(Map<String, dynamic> json) {
    MyCourse myCourse = MyCourse(
      id: json['id'] as int?,
      title: json['title'] as String?,
      slug: json['slug'] as String?,
      shortDescription: json['short_description'] as String?,
      userId: json['user_id'] as int?,
      categoryId: json['category_id'] as int?,
      courseType: json['course_type'] as String?,
      status: json['status'] as String?,
      level: json['level'] as String?,
      language: json['language'] as String?,
      // Convert int (1/0) to bool (true/false)
      isPaid: (json['is_paid'] as int?) == 1,
      isBest: (json['is_best'] as int?) == 1,
      price: json['price'] as String?,
      priceForPayment: (json['price_for_payment'] as num?)?.toDouble(),
      discountedPrice: json['discounted_price'] as num?,
      discountFlag: (json['discount_flag'] as int?) == 1,
      enableDripContent: (json['enable_drip_content'] as int?) == 1,
      dripContentSettings: json['drip_content_settings'] as String?,
      metaKeywords: json['meta_keywords'] as String?,
      metaDescription: json['meta_description'] as String?,
      thumbnail: json['thumbnail'] as String?,
      banner: json['banner'] as String?,
      preview: json['preview'] as String?,
      description: json['description'] as String?,
      requirements: _mapOrListToStringList(json['requirements']),
      outcomes: _mapOrListToStringList(json['outcomes']),
      faqs:
          (json['faqs'] as List<dynamic>?)
              ?.map(
                (e) => {
                  'title': e['title'].toString(),
                  'description': e['description'].toString(),
                },
              )
              .toList(),

      instructorIds: json['instructor_ids'] as String?,
      // Convert String to double
      averageRating: double.tryParse(
        json['average_rating'] as String? ?? '0.0',
      ),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      expiryPeriod: json['expiry_period'] as String?,
      // Instructors list conversion
      instructors: (json['instructors'] as List<dynamic>?)?.cast<String>(),
      priceCart: json['price_cart'] as num?,
      instructorName: json['instructor_name'] as String?,
      instructorProfile: json['instructor_profile'] as String?,
      instructorImage: json['instructor_image'] as String?,
      totalEnrollment: json['total_enrollment'] as int?,
      shareableLink: json['shareable_link'] as String?,
      totalReviews: json['total_reviews'] as int?,

      totalNumberOfCompletedLessons:
          json['total_number_of_completed_lessons'] as int?,
      totalNumberOfLessons: json['total_number_of_lessons'] as int?,
      completion: json['completion'] as num?,
    );
    return myCourse;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'short_description': shortDescription,
      'user_id': userId,
      'category_id': categoryId,
      'course_type': courseType,
      'status': status,
      'level': level,
      'language': language,
      // Convert bool back to int (1/0)
      'is_paid': isPaid == true ? 1 : 0,
      'is_best': isBest == true ? 1 : 0,
      'price': price,
      'price_for_payment': priceForPayment,
      'discounted_price': discountedPrice,
      'discount_flag': discountFlag == true ? 1 : 0,
      'enable_drip_content': enableDripContent == true ? 1 : 0,
      'drip_content_settings': dripContentSettings,
      'meta_keywords': metaKeywords,
      'meta_description': metaDescription,
      'thumbnail': thumbnail,
      'banner': banner,
      'preview': preview,
      'description': description,
      'requirements': requirements,
      'outcomes': outcomes,
      'faqs': faqs,
      'instructor_ids': instructorIds,
      // Convert double back to String
      'average_rating': averageRating?.toString(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'expiry_period': expiryPeriod,
      'instructors': instructors,
      'price_cart': priceCart,
      'instructor_name': instructorName,
      'instructor_profile': instructorProfile,
      'instructor_image': instructorImage,
      'total_enrollment': totalEnrollment,
      'shareable_link': shareableLink,
      'total_reviews': totalReviews,
      'total_number_of_completed_lessons': totalNumberOfCompletedLessons,
      'total_number_of_lessons': totalNumberOfLessons,
      'completion': completion,
    };
  }

  Future<void> calculateTotalDuration() async {
    // Check if the course ID is valid before fetching sections
    if (id == null) return;

    final sectionController = Get.put(SectionController());
    final List<Section> sections = await sectionController.getSections(id!);

    // (Ensure durationToSeconds is accessible/imported)
    int totalSeconds = sections.fold(0, (sum, section) {
      String durationString = section.totalDuration ?? '00:00:00';
      return sum + durationToSeconds(durationString);
    });

    String displayDurationString;
    if (totalSeconds < 3600) {
      int minutes = totalSeconds ~/ 60;
      int seconds = totalSeconds % 60;
      if (minutes > 0) {
        displayDurationString = '${minutes}m ${seconds}s';
      } else {
        displayDurationString = '${seconds}s';
      }
    } else {
      int hours = totalSeconds ~/ 3600;
      int remainingMinutes = (totalSeconds % 3600) ~/ 60;
      displayDurationString = '${hours}h ${remainingMinutes}m';
    }

    // ⭐️ Assign the calculated value directly to the property
    totalDuration = displayDurationString;
  }

  static List<String>? _mapOrListToStringList(dynamic data) {
    if (data == null) return [];

    if (data is List) {
      return data.map((e) => e.toString()).toList();
    }

    if (data is Map) {
      return data.values.map((e) => e.toString()).toList();
    }

    return [];
  }
}
