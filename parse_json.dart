import 'dart:convert';
import 'dart:io';

void main() {
  var body = File('all_product.json').readAsStringSync();
  var data = jsonDecode(body);
  if (data is Map) {
      if (data['data'] != null) {
          var list = data['data'] as List;
          print("Total products in data['data']: ${list.length}");
          var p0 = list[0];
          print("Keys in product: ${p0.keys.toList()}");
          var match = list.where((p) => p['sub_subcategory_id']?.toString() == '15' || p['sub_subcategory_id']?.toString() == '9' || p['sub_category_id']?.toString() == '15' || p['sub_category_id']?.toString() == '9').toList();
          print("Matches for 9 or 15: ${match.length}");
      }
      if (data['product'] != null) {
          var list = data['product'] as List;
          print("Total products in data['product']: ${list.length}");
      }
  } else if (data is List) {
      print("Total products in root array: ${data.length}");
      var p0 = data[0];
      print("Keys in product: ${p0.keys.toList()}");
      var match = data.where((p) => p['sub_subcategory_id']?.toString() == '15' || p['sub_subcategory_id']?.toString() == '9' || p['sub_category_id']?.toString() == '15' || p['sub_category_id']?.toString() == '9').toList();
      print("Matches for 9 or 15: ${match.length}");
  }
}
