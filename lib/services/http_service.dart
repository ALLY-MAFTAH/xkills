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
      final fullUrl = '${Endpoints.baseUrl}/$url';

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

  static dynamic _handleResponse(http.Response response) async {
    if (response.statusCode == 401) {
      final responseData = jsonDecode(response.body);
      String message = responseData['message'];
      throw message;
    } else if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);

      return responseData;
    }
    if (response.statusCode == 500) {
      print(response.statusCode);
      print(response.body);
      String message = "Server error";

      throw message;
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      final responseData = jsonDecode(response.body);
      String message = responseData['message'];
      throw message;
    } else if (response.statusCode == 409) {
      final responseData = jsonDecode(response.body);

      String? message = responseData['message'];
      message ??= responseData['errors'].toString();
      throw message;
    } else if (response.statusCode == 415) {
      final responseData = jsonDecode(response.body);
      String title = responseData['title'];

      throw title;
    } else {
      final responseData = jsonDecode(response.body);
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
      final uri = Uri.parse('${Endpoints.baseUrl}/$url');

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
