import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '/controllers/auth_controller.dart';
import '../models/user.dart';

class Auth {
  static final Auth auth = Auth._internal();
  factory Auth() {
    return auth;
  }

  Auth._internal();

  User? _user;
  final GetStorage _storage = GetStorage();

  User? get user => _user;

  Future<void> loadAuthUser() async {
    final authController = Get.put(AuthController());
    await authController.getUserData();
    final fetchedAuth = _storage.read("authUser");
    if (fetchedAuth != null) {
      _user = User.fromJson(jsonDecode(fetchedAuth));
    }
  }

  void saveAuthUser(User user) {
    _user = user;
    _storage.write("authUser", jsonEncode(user.toJson()));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (_user != null) {
      var memberName = invocation.memberName.toString();
      memberName = memberName.substring(8, memberName.length - 2);
      var properties = _user!.toJson();
      if (invocation.isGetter && properties.containsKey(memberName)) {
        return properties[memberName];
      }
      if (invocation.isSetter && properties.containsKey(memberName)) {
        properties[memberName] = invocation.positionalArguments[0];
        _user = User.fromJson(properties);
      }
    }
    return super.noSuchMethod(invocation);
  }
}
