// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../model/delete_card_model.dart';
import '../model/get_new_cart_model.dart';
import '../utils/const.dart';
import '../utils/globel_veriable.dart';

class AddCard {
  static Future<GetNewCartModel> addCart(
      {required String productId,
      required String goldPurity,
      required String bangleSize,
      required String instruction,
      required String weight}) async {
    try {
      final url =
          '${apiUrl}addCart/?userid=${GlobalK.userId}&productid=$productId&gold_purity=$goldPurity&bangle_size=$bangleSize&weight=$weight&instruction=$instruction';
      // print('AddCart URL: $url');
      var response = await http.get(Uri.parse(url));
      
      print('Add Cart Response: ${response.body}'); // For debugging

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        Fluttertoast.showToast(msg: 'Successfully Add Product');
        return GetNewCartModel.fromJson(data);
      }
      throw Exception('Failed to add to cart: ${response.statusCode}');
    } catch (e) {
      print('Add Cart Error: $e'); // For debugging
      throw Exception('Failed to add to cart: $e');
    }
  }

  static Future<GetNewCartModel> UpdateCard(
      {String? product_id, String? quantity}) async {
    var response = await http.get(Uri.parse(
        '${apiUrl}updateCart/?userid=${GlobalK.userId}&productid=$product_id&quantity=$quantity&productid=$product_id'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: 'Show the  Product');
      // Get.snackbar('Qunatity', '$quantity');
      // Get.to(()=>CartPage());
      Fluttertoast.showToast(
          msg: '${response.statusCode} || ${response.reasonPhrase}');
    }
    return GetNewCartModel.fromJson(data);
  }

  static Future<DeleteCardModel> getDeleteCard(
      {String? product_id, String? quantity}) async {
    try {
      var response = await http.post(
        Uri.parse('${apiUrl}deleteCart?userid=${GlobalK.userId}&productid=$product_id&quantity=$quantity')
      );
      
      print('Delete Cart Response: ${response.body}'); // For debugging

      if (response.statusCode == 200) {
        // Fluttertoast.showToast(msg: 'Successfully delete Product');
        //Get.to(()=>CartPage());
        var data = jsonDecode(response.body);
        return DeleteCardModel.fromJson(data);
      }
      throw Exception('Failed to delete from cart: ${response.statusCode}');
    } catch (e) {
      print('Delete Cart Error: $e'); // For debugging
      throw Exception('Failed to delete from cart: $e');
    }
  }

  static Future<GetNewCartModel> getCard() async {
    try {
      var request = http.Request('GET',
          Uri.parse('https://briio.in/api/getCart?userid=${GlobalK.userId}'));

      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      print('Cart Response: $responseBody'); // For debugging

      if (response.statusCode == 200) {
        if (responseBody.isEmpty) {
          throw Exception('Empty response received');
        }
        return GetNewCartModel.fromJson(jsonDecode(responseBody));
      } else {
        throw Exception('Failed to load cart: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Cart Error: $e'); // For debugging
      throw Exception('Failed to load cart: $e');
    }
  }
}
