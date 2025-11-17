String getVideoWithExtension(String url) {
  try {
    Uri uri = Uri.parse(url);
    return uri.pathSegments.last;
  } catch (_) {
    return '';
  }
}
