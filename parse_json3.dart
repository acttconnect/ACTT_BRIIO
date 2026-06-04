import 'dart:convert';
import 'dart:io';

void main() {
  var body = File('all_product.json').readAsStringSync();
  var data = jsonDecode(body);
  if (data is Map) {
      if (data['product'] != null) {
          var list = data['product'] as List;
          print("Total products in data['product']: ${list.length}");
          var match = list.where((p) => p['sub_sub_category_id']?.toString() == '15' || p['sub_sub_category_id']?.toString() == '9' || p['subcategory_id']?.toString() == '15' || p['subcategory_id']?.toString() == '9').toList();
          print("Matches for 9 or 15: ${match.length}");
          if (match.isNotEmpty) {
              print("First match subcat: ${match[0]['subcategory_id']}, subsubcat: ${match[0]['sub_sub_category_id']}");
              print("Count with subcategory_id = 9: ${list.where((p) => p['subcategory_id']?.toString() == '9').length}");
              print("Count with sub_sub_category_id = 9: ${list.where((p) => p['sub_sub_category_id']?.toString() == '9').length}");
              print("Count with subcategory_id = 15: ${list.where((p) => p['subcategory_id']?.toString() == '15').length}");
              print("Count with sub_sub_category_id = 15: ${list.where((p) => p['sub_sub_category_id']?.toString() == '15').length}");
          }
      }
  }
}
