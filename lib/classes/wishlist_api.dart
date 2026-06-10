import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/const.dart';
import '../utils/globel_veriable.dart';

class WishlistItem {
  final int? productId;

  WishlistItem({this.productId});

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    int? pid;
    if (json['product_id'] != null) {
      pid = int.tryParse(json['product_id'].toString());
    } else if (json['productid'] != null) {
      pid = int.tryParse(json['productid'].toString());
    }
    return WishlistItem(productId: pid);
  }
}

class WishlistApi {
  static Future<List<WishlistItem>> getWishlistData() async {
    try {
      final url = '${apiUrl}getWishlist?userid=${GlobalK.userId}&productid=1&productvariantid=1';
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['error'] == false && data['data'] != null) {
          return (data['data'] as List).map((e) => WishlistItem.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print('Error loading wishlist data: $e');
    }
    return [];
  }
}
