class Instructor {
  int? id;
  String? role;
  String? email;
  int? status;
  String? name;
  String? phone;
  String? website;
  String? skills;
  String? facebook;
  String? twitter;
  String? linkedin;
  String? address;
  String? about;
  String? biography;
  String? educations;
  String? photo;
  String? emailVerifiedAt; // Timestamp string
  String? paymentkeys; // JSON string
  String? videoUrl;
  String? createdAt; // Timestamp string
  String? updatedAt; // Timestamp string
  int? totalCourses; // The custom count field

  Instructor({
    this.id,
    this.role,
    this.email,
    this.status,
    this.name,
    this.phone,
    this.website,
    this.skills,
    this.facebook,
    this.twitter,
    this.linkedin,
    this.address,
    this.about,
    this.biography,
    this.educations,
    this.photo,
    this.emailVerifiedAt,
    this.paymentkeys,
    this.videoUrl,
    this.createdAt,
    this.updatedAt,
    this.totalCourses,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'] as int?,
      role: json['role'] as String?,
      email: json['email'] as String?,
      status: json['status'] as int?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      skills: json['skills'] as String?,
      facebook: json['facebook'] as String?,
      twitter: json['twitter'] as String?,
      linkedin: json['linkedin'] as String?,
      address: json['address'] as String?,
      about: json['about'] as String?,
      biography: json['biography'] as String?,
      educations: json['educations'] as String?,
      photo: json['photo'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      paymentkeys: json['paymentkeys'] as String?,
      videoUrl: json['video_url'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      totalCourses: json['total_courses'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'email': email,
      'status': status,
      'name': name,
      'phone': phone,
      'website': website,
      'skills': skills,
      'facebook': facebook,
      'twitter': twitter,
      'linkedin': linkedin,
      'address': address,
      'about': about,
      'biography': biography,
      'educations': educations,
      'photo': photo,
      'email_verified_at': emailVerifiedAt,
      'paymentkeys': paymentkeys,
      'video_url': videoUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'total_courses': totalCourses,
    };
  }
}