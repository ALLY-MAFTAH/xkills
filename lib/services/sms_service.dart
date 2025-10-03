import 'dart:convert';

import 'package:http/http.dart' as http;

import '../components/toasts.dart';

class SmsService {
  Future<void> sendSms({
    required String to,
    required String message,
    required String reference,
  }) async {
    final url = Uri.parse(
      'https://messaging-service.co.tz/api/sms/v1/text/single',
    );

    final headers = {
      'Authorization': 'Basic TUFMRVpJOk1hbGV6aUBGR0s=',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = json.encode({
      "from": "MaleziApp",
      "to": to,
      "text": message,
      "reference": reference,
    });

    try {
      final request = http.Request('POST', url);
      request.headers.addAll(headers);
      request.body = body;

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print("SMS Sent Successfully: $responseBody");
      } else {
        print("Failed to send SMS: ${response.reasonPhrase}");
        errorToast(response.reasonPhrase.toString());
      }
    } catch (e) {
      print("Error sending SMS: $e");
    } finally {
      to = "";
      message = "";
      reference = '';
    }
  }

  String generateReference(String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$prefix$timestamp';
  }
}
