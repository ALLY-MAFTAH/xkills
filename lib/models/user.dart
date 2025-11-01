class User {
  int? id;
  String? name;
  String? role;
  String? email;
  String? phone;
  int? status;
  String? photo;
  String? address;

  User({
    this.id,
    this.name,
    this.role,
    this.email,
    this.phone,
    this.status,
    this.photo,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var user = User(
      id: json['id'] as int?,
      name: json['name'] as String?,
      role: json['role'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      status: json['status'] as int?,
      photo: json['photo'] as String?,
      address: json['address'] as String?,
    );
    return user;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'name': name,
      'email': email,
      'phone': phone,
      'status': status,
      'photo': photo,
      'address': address,
    };
  }
}
