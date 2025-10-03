
class User {
  int? id;
  String? email;
  String? phone;
  String? accountType;
  bool? isFirstLogin;
  bool? isActive;
  bool? isSuperAdmin;
  DateTime? lastLogin;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? resetToken;
  DateTime? resetTokenExpiry;
  String? profilePictureUrl;
  String? fullName;

  User({
    this.id,
    this.email,
    this.phone,
    this.accountType,
    this.isFirstLogin,
    this.isActive,
    this.isSuperAdmin,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
    this.resetToken,
    this.resetTokenExpiry,
    this.profilePictureUrl,
    this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) {

    var user = User(
      id: json['userId'] as int?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      accountType: json['accountType'] as String?,
      isFirstLogin: json['isFirstLogin'] as bool?,
      isActive: json['isActive'] as bool?,
      isSuperAdmin: json['isSuperAdmin'] as bool?,
    );
    user._setFullName();
    return user;
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'email': email,
      'phone': phone,
      'accountType': accountType,
      'isFirstLogin': isFirstLogin,
      'isActive': isActive,
      'isSuperAdmin': isSuperAdmin,
    };
  }

  void _setFullName() {
    fullName = phone;
  }
}
