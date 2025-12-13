class Category {
  int? id;
  int? parentId;
  String? title;
  String? slug;
  String? icon;
  int? sort;
  String? status;
  String? keywords;
  String? description;
  String? thumbnail;
  String? categoryLogo;
  String? createdAt;
  String? updatedAt;
  int? numberOfCourses;
  int? numberOfSubCategories;
  List<dynamic>? childs;
  // 1. New attribute added
  bool? isGolden; 

  Category({
    this.id,
    this.parentId,
    this.title,
    this.slug,
    this.icon,
    this.sort,
    this.status,
    this.keywords,
    this.description,
    this.thumbnail,
    this.categoryLogo,
    this.createdAt,
    this.updatedAt,
    this.numberOfCourses,
    this.numberOfSubCategories,
    this.childs,
    this.isGolden, // Included in the constructor
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    String? goldenTitle = json['title'] as String?;
    
    // 2. Logic to check for "Golden" in keywords (case-insensitive)
    bool isGoldenCategory = goldenTitle?.toLowerCase().contains('golden') ?? false;

    return Category(
      id: json['id'] as int?,
      parentId: json['parent_id'] as int?,
      title: json['title'] as String?,
      slug: json['slug'] as String?,
      icon: json['icon'] as String?,
      sort: json['sort'] as int?,
      status: json['status'] as String?,
      keywords: json['keywords'] as String?,
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] as String?,
      categoryLogo: json['category_logo'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      numberOfCourses: json['number_of_courses'] as int?,
      numberOfSubCategories: json['number_of_sub_categories'] as int?,
      childs: json['childs'] as List<dynamic>?,
      isGolden: isGoldenCategory, // 3. Attribute assigned
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'title': title,
      'slug': slug,
      'icon': icon,
      'sort': sort,
      'status': status,
      'keywords': keywords,
      'description': description,
      'thumbnail': thumbnail,
      'category_logo': categoryLogo,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'number_of_courses': numberOfCourses,
      'number_of_sub_categories': numberOfSubCategories,
      'childs': childs,
      'isGolden': isGolden, // Included in toJson
    };
  }
}