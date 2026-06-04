import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'const.dart';
import 'globel_veriable.dart';

class MyController extends GetxController {
  RxBool isCartLoading = false.obs;
}

class CartOrder {
  static final c = Get.put(MyController());
  static Future<void> placeOrder({
    required int productId,
    required int addressId,
    required String goldPurity,
    required String bangleSize,
    required String weight,
    required String instruction,
  }) async {
    final url =
        '${apiUrl}submitOrderData?user_id=${GlobalK.userId}&product_id=$productId&address_id=$addressId&payment_method=COD&gold_purity=$goldPurity&bangle_size=$bangleSize&weight=$weight&instruction=$instruction';
    c.isCartLoading.value = true;
    final response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      c.isCartLoading.value = false;
      if (data['error'] == false) {
        Get.back();
        Get.defaultDialog(
          backgroundColor: Colors.white,
          title: '',
          titleStyle: const TextStyle(fontSize: 0),
          middleText: 'Thank You for choosing \n BRIIO!\n Your order will be confirmed shortly.',
          // textAlign: TextAlign.center,
          middleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          confirm: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
            ),
            onPressed: () => Get.back(),
            child: const Text('OK', style: TextStyle(color: Colors.black)),
          ),
        );
        Fluttertoast.showToast(msg: 'Order Placed Successfully');
      } else {
        Fluttertoast.showToast(msg: 'Product not found');
      }
    } else {
      c.isCartLoading.value = false;
      Fluttertoast.showToast(msg: response.reasonPhrase.toString());
    }
  }
}
