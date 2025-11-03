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
  List<dynamic>? requirements;
  List<dynamic>? outcomes;
  List<dynamic>? faqs;
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
  });

  factory MyCourse.fromJson(Map<String, dynamic> json) {
    return MyCourse(
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
      // Lists of dynamic content
      requirements: json['requirements'] as List<dynamic>?,
      outcomes: json['outcomes'] as List<dynamic>?,
      faqs: json['faqs'] as List<dynamic>?,
      instructorIds: json['instructor_ids'] as String?,
      // Convert String to double
      averageRating: double.tryParse(json['average_rating'] as String? ?? '0.0'),
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
    );
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
    };
  }
}