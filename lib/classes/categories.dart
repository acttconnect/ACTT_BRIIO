import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/catogries_model.dart';
import '../utils/const.dart';

import '../utils/globel_veriable.dart';

class CategoriesView {
  static Future<CatogriesModel> getPro() async {
    String uri = '${apiUrl}Categorie';
    if (GlobalK.mainCategoryId != null) {
      uri += '?main_category_id=${GlobalK.mainCategoryId}';
    }
    try {
      final response = await http.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return CatogriesModel.fromJson(data);
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      throw Exception('Failed to load categories: $e');
    }
  }
}
