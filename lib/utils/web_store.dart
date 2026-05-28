import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/toasts.dart';
import '../constants/endpoints.dart';
import '../models/course.dart';

/// Opens the web app in the system browser (Safari / Chrome).
/// The native app does not sell digital goods; discovery only.
Future<void> openWebStorePath(String path) async {
  final base = Endpoints.webStoreBaseUrl.replaceAll(RegExp(r'/+$'), '');
  final normalized = path.startsWith('/') ? path : '/$path';
  final uri = Uri.parse('$base$normalized');
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok) {
    errorToast('Could not open browser'.tr);
  }
}

/// Open the course page on the public website (no in-app commerce).
Future<void> openWebCoursePage(Course course) async {
  final slug = course.slug?.trim();
  if (slug != null && slug.isNotEmpty) {
    await openWebStorePath('/course/$slug');
  } else {
    await openWebStorePath('/courses');
  }
  successToast('Opening the Xkills website in your browser.'.tr);
}
