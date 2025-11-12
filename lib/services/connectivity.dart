import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> hasInternet() async {
  try {
    final connectivityResult = await Connectivity()
        .checkConnectivity()
        .timeout(const Duration(seconds: 30));

    if (connectivityResult.isEmpty) {
      print("THERE IS NO INTERNET :::::::::::");
      return false;
    } else {
      return true;
    }
  } catch (e) {
    print("Connectivity check failed: $e");
    return false;
  }
}

Future<bool> hasNoInternet() async {
  return !(await hasInternet());
}
