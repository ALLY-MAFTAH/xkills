/// Fixes image URLs returned by the production server.
///
/// Nginx serves the Laravel project with root = /var/www/xkills/public,
/// so ASSET_URL=https://xkills.app is correct and URLs need no /public/ prefix.
/// This function is now a no-op but kept for compatibility.
String fixImageUrl(String url) {
  if (url.isEmpty) return url;

  const host = 'xkills.app';

  final uri = Uri.tryParse(url);
  if (uri == null || uri.host != host) return url;

  final path = uri.path;

  // Already has /public/ prefix — strip it since Nginx root is already /public.
  if (path.startsWith('/public/')) {
    return uri.replace(path: path.replaceFirst('/public', '')).toString();
  }

  return url;
}
