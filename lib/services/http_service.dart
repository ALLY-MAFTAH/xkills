// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import '../constants/endpoints.dart';
import '../enums/enums.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'connectivity.dart';

class HttpService {
  /// Supports either a path segment (`api/login`) or a full URL from `.env`.
  static String _resolveUrl(String url) {
    final u = url.trim();
    if (u.startsWith('http://') || u.startsWith('https://')) {
      return u;
    }
    final base = Endpoints.baseUrl.replaceAll(RegExp(r'/$'), '');
    final path = u.replaceAll(RegExp(r'^/'), '');
    return '$base/$path';
  }

  static Future<dynamic> sendHttpRequest(
    String endpointName,
    RequestType requestType,
    String url,
    dynamic body, {
    bool? isAuthRequest = true,
  }) async {
    Map<String, String> headers;
    print("Endpoint Name: ");
    print(endpointName);
    try {
      final storage = GetStorage();
      final userToken = storage.read("userToken");
      final fullUrl = _resolveUrl(url);

      isAuthRequest == false
          ? headers = <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }
          : headers = <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $userToken',
          };

      if (await hasNoInternet()) {
        throw "Check Your Internet Connection".tr;
      }

      if (requestType == RequestType.GET) {
        Map<String, String> queryParams = {};
        if (body is Map) {
          body.forEach((key, value) {
            if (key != null && value != null) {
              queryParams[key.toString()] = value.toString();
            }
          });
        }
        final urlWithParams = Uri.parse(
          fullUrl,
        ).replace(queryParameters: queryParams);
        final response = await http
            .get(urlWithParams, headers: headers)
            .timeout(const Duration(seconds: 30));

        return _handleResponse(response);
      }

      if (requestType == RequestType.POST) {
        final response = await http
            .post(Uri.parse(fullUrl), headers: headers, body: jsonEncode(body))
            .timeout(const Duration(seconds: 30));

        return _handleResponse(response);
      } else if (requestType == RequestType.PUT) {
        final response = await http
            .put(Uri.parse(fullUrl), headers: headers, body: jsonEncode(body))
            .timeout(const Duration(seconds: 30));

        return _handleResponse(response);
      } else if (requestType == RequestType.PATCH) {
        final response = await http
            .patch(Uri.parse(fullUrl), headers: headers, body: jsonEncode(body))
            .timeout(const Duration(seconds: 30));
        return _handleResponse(response);
      } else if (requestType == RequestType.DELETE) {
        final response = await http
            .delete(
              Uri.parse(fullUrl),
              headers: headers,
              body: jsonEncode(body),
            )
            .timeout(const Duration(seconds: 30));
        return _handleResponse(response);
      } else {
        return null;
      }
    } catch (ex) {
      if (ex is TimeoutException) {
        print("::::::::::::::::::::::::::");
        print(ex.toString());
        throw "Request Timed Out, Please Try Again.".tr;
      }
      if (ex is http.ClientException) {
        print(ex.toString());
        throw "Server Not Reached, Please Try Again.".tr;
      } else {
        print("EXCEPTION:::::::::::::::");
        print(ex.toString());
        throw ex.toString();
      }
    }
  }

  static bool _looksLikeHtml(String body, String? contentType) {
    final ct = (contentType ?? '').toLowerCase();
    if (ct.contains('text/html')) return true;
    final b = body.trimLeft();
    return b.startsWith('<!doctype html') ||
        b.startsWith('<html') ||
        b.startsWith('<');
  }

  static dynamic _decodeJsonOrThrow(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      // Accept both JSON objects (Map) and JSON arrays (List)
      if (decoded is Map<String, dynamic> || decoded is List) return decoded;
      throw 'Unexpected JSON shape';
    } catch (e) {
      if (e is! String) {
        // jsonDecode itself threw — check if the body is HTML
        final contentType = response.headers['content-type'];
        if (_looksLikeHtml(response.body, contentType)) {
          final snippet = response.body.trim().replaceAll(RegExp(r'\s+'), ' ');
          final short = snippet.length > 140 ? '${snippet.substring(0, 140)}…' : snippet;
          throw 'Server returned HTML (status ${response.statusCode}). Check your `.env` API endpoints / BASE_URL.\n$short';
        }
        throw 'Invalid server response (status ${response.statusCode}). Expected JSON.';
      }
      rethrow;
    }
  }

  static dynamic _handleResponse(http.Response response) {
    final contentType = response.headers['content-type'];
    if (_looksLikeHtml(response.body, contentType)) {
      final snippet = response.body.trim().replaceAll(RegExp(r'\s+'), ' ');
      final short = snippet.length > 140 ? '${snippet.substring(0, 140)}…' : snippet;
      throw 'Server returned HTML (status ${response.statusCode}). Check your `.env` API endpoints / BASE_URL.\n$short';
    }

    if (response.statusCode == 401) {
      final responseData = _decodeJsonOrThrow(response);
      final String message = (responseData['message'] ?? 'Unauthorized').toString();
      throw message;
    } else if (response.statusCode == 200 || response.statusCode == 201) {
      return _decodeJsonOrThrow(response);
    }
    if (response.statusCode == 503) {
      try {
        final responseData = _decodeJsonOrThrow(response);
        throw (responseData['message'] ?? 'Service temporarily unavailable')
            .toString();
      } catch (_) {
        throw 'Service temporarily unavailable';
      }
    }
    if (response.statusCode == 500) {
      print(response.statusCode);
      print(response.body);
      String message = "Server error";

      throw message;
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      final responseData = _decodeJsonOrThrow(response);
      final String message = (responseData['message'] ?? 'Request failed').toString();
      throw message;
    } else if (response.statusCode == 422) {
      final responseData = _decodeJsonOrThrow(response);
      final dynamic errs = responseData['errors'];
      if (errs is Map) {
        for (final dynamic v in errs.values) {
          if (v is List && v.isNotEmpty) {
            throw v.first.toString();
          }
          if (v is String && v.isNotEmpty) {
            throw v;
          }
        }
      }
      throw responseData['message']?.toString() ?? 'Invalid request';
    } else if (response.statusCode == 409) {
      final responseData = _decodeJsonOrThrow(response);

      String? message = responseData['message'];
      message ??= responseData['errors'].toString();
      throw message;
    } else if (response.statusCode == 415) {
      final responseData = _decodeJsonOrThrow(response);
      final String title = (responseData['title'] ?? 'Unsupported Media Type').toString();

      throw title;
    } else {
      final responseData = _decodeJsonOrThrow(response);
      Map<String, dynamic>? errors =
          responseData['errors'] ?? responseData['validationError'];

      if (errors != null) {
        for (var entry in errors.entries) {
          throw entry.value[0];
        }
      }
    }
  }

  Future<dynamic> sendMultipartRequest({
    required String url,
    XFile? file,
    required Map<String, String> fields,
    String fileFieldName = 'photo',
    RequestType method = RequestType.POST,
  }) async {
    try {
      final storage = GetStorage();
      final userToken = storage.read("userToken");
      final uri = Uri.parse(_resolveUrl(url));

      final request =
          http.MultipartRequest(method.name, uri)
            ..headers.addAll({
              'Authorization': 'Bearer $userToken',
              'Accept': 'application/json',
            })
            ..fields.addAll(fields);
      if (await hasNoInternet()) {
        throw "Check Your Internet Connection".tr;
      }
      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            fileFieldName,
            file.path,
            filename: file.name,
            contentType: MediaType('image', 'jpeg'),
          ).timeout(const Duration(seconds: 60)),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (ex) {
      if (ex is TimeoutException) {
        throw "Request Timed Out, Please Try Again.".tr;
      }
      if (ex is http.ClientException) {
        throw "Server Not Reached, Please Try Again.".tr;
      } else {
        throw ex.toString();
      }
    }
  }
}
