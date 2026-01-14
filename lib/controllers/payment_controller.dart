import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../includes/checkout_webview.dart';
import '../models/payment.dart';
import '/constants/auth_user.dart';
import '/constants/endpoints.dart';

import '../components/toasts.dart';
import '../enums/enums.dart';

class PaymentController extends GetxController {
  bool isLoading = false;
  TextEditingController phoneController = TextEditingController();
  Future<List<Payment>>? paymentsFuture;
  final List<Payment> _payments = [];
  List<Payment> get payments => _payments;
  PaymentMethod? selectedMethod = PaymentMethod.NONE;

  Future<List<Payment>> getPaymentHistory() async {
    // Implement your logic to fetch payment history here
    return [];
  }

  Future<String?> submitCardPayment(
    List<int> courseIds,
    double totalAmount,
    BuildContext context,
  ) async {
    isLoading = true;
    update();
    print(courseIds);
    print(totalAmount);
    try {
      const url = "https://zenoapi.com/api/payments/checkout/";
      final String apiKey = Endpoints.apiKey;

      final String buyerPhone = "0${phoneController.text.trim()}";
      final String buyerEmail = Auth().user!.email!;
      final String buyerName = Auth().user!.name!;
      final int amount = totalAmount.toInt();
      final String productId =
          courseIds.length == 1 ? courseIds[0].toString() : courseIds.join(",");
      final int orderId = int.parse(
        "${Auth().user!.id}${(Random().nextInt(9000000) + 1000000).toString()}",
      );
      print(buyerPhone);
      print(buyerEmail);
      print(buyerName);
      print(productId);
      print(orderId);
      print(amount);
      print(apiKey);

      Map<String, dynamic> data = {
        "order_id": orderId.toInt(),
        "buyer_email": buyerEmail,
        "buyer_name": buyerName,
        "buyer_phone": buyerPhone,
        "currency": "TZS",
        "amount": amount,
        "webhook_url": "",
        "redirect_url": "https://zenopay.net",
      };

      var dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['x-api-key'] = apiKey;

      var response = await dio.post(url, data: data);
      print(response);
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200 ||
          response.statusCode == 201 && response.data['payment_link'] != null) {
        String paymentLink = response.data['payment_link'];
        print("payment link iSS ::::::::");
        print(paymentLink);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CompletePaymentWebView(url: paymentLink),
          ),
        );
        return orderId.toString();
      }
    } catch (ex) {
      update();
      print(ex.toString());
      errorToast(ex.toString());
    } finally {
      phoneController.clear();
      isLoading = false;
      update();
    }
    return null;
  }

  Future<String?> submitMobilePayment(
    List<int> courseIds,
    double totalAmount,
    BuildContext context,
  ) async {
    isLoading = true;
    update();
    print(courseIds);
    print(totalAmount);
    try {
      const url = "https://zenoapi.com/api/payments/mobile_money_tanzania";
      final String apiKey = Endpoints.apiKey;

      final String buyerPhone = "0${phoneController.text.trim()}";
      final String buyerEmail = Auth().user!.email!;
      final String buyerName = Auth().user!.name!;
      final int amount = totalAmount.toInt();
      final String productId =
          courseIds.length == 1 ? courseIds[0].toString() : courseIds.join(",");
      final int orderId = int.parse(
        "${Auth().user!.id}${(Random().nextInt(9000000) + 1000000).toString()}",
      );
      print(buyerPhone);
      print(buyerEmail);
      print(buyerName);
      print(productId);
      print(orderId);
      print(amount);
      print(apiKey);

      Map<String, dynamic> data = {
        "order_id": orderId.toInt(),
        "buyer_email": buyerEmail,
        "buyer_name": buyerName,
        "buyer_phone": buyerPhone,
        "amount": amount,
        "webhook_url": "",
        "metadata": {
          "product_id": productId,
          "custom_notes": "Paid via SkillsBank App",
        },
      };

      var dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['x-api-key'] = apiKey;

      var response = await dio.post(url, data: data);
      print(response.data);
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return orderId.toString();
      }
    } catch (ex) {
      update();
      print(ex.toString());
      errorToast(ex.toString());
    } finally {
      phoneController.clear();
      isLoading = false;
      update();
    }
    return null;
  }

  Future<void> checkPaymentStatus(BuildContext context, String orderId) async {
    final String apiKey = Endpoints.apiKey;
    final url =
        "https://zenoapi.com/api/payments/order-status?order_id=$orderId";

    try {
      var dio = Dio();
      dio.options.headers['x-api-key'] = apiKey;

      final response = await dio.get(url);

      if (response.statusCode == 200 &&
          response.data['data'][0]['payment_status'] == "COMPLETED") {
        var paymentData = response.data['data'][0];

        await recordPayment({
          "transaction_id": orderId,
          "amount": paymentData['amount'],
          "reference_number": paymentData['reference'],
          "mobile": paymentData['msisdn'],
          "channel": paymentData['channel'],
          "transid": paymentData['transid'],
        });
        successToast("payment_success".tr);
      } else {
        errorToast("payment_failed".tr);
      }
    } catch (e) {
      errorToast("payment_status_error".tr);
      print(e);
    }
  }

  Future<void> recordPayment(Map<String, dynamic> map) async {}
}
