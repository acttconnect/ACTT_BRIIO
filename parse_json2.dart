import 'dart:convert';
import 'dart:io';

void main() {
  var body = File('all_product.json').readAsStringSync();
  var data = jsonDecode(body);
  if (data is Map) {
      if (data['product'] != null) {
          var list = data['product'] as List;
          print("Total products in data['product']: ${list.length}");
          var p0 = list[0];
          print("Keys in product: ${p0.keys.toList()}");
          var match = list.where((p) => p['sub_subcategory_id']?.toString() == '15' || p['sub_subcategory_id']?.toString() == '9' || p['sub_category_id']?.toString() == '15' || p['sub_category_id']?.toString() == '9').toList();
          print("Matches for 9 or 15: ${match.length}");
          if (match.isNotEmpty) {
              print("First match subcat: ${match[0]['sub_category_id']}, subsubcat: ${match[0]['sub_subcategory_id']}");
          }
      }
  }
}
