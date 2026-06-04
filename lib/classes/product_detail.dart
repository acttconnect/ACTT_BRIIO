import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/new_detail_page_model.dart';
import '../utils/const.dart';
import '../utils/globel_veriable.dart';

class ProductById {
  static Future<NewDetailPageModel> getProductById() async {
    try {
      var response = await http
          .post(Uri.parse('${apiUrl}ProductById?id=${GlobalK.productId?.trim()}'));
      
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return NewDetailPageModel.fromJson(data);
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
