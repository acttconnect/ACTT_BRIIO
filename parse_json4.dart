import 'dart:convert';
import 'dart:io';

void main() {
  try {
    var body = File('all_product.json').readAsStringSync();
    var data = jsonDecode(body);
    if (data is Map) {
      if (data['product'] != null) {
        var list = data['product'] as List;
        print("Total products: ${list.length}");
        var match = list.where((p) => p['name'].toString().toLowerCase().contains('jumper')).toList();
        if (match.isNotEmpty) {
            print("Found JUMPER products! Count: ${match.length}");
            print("First match category_id: ${match[0]['category_id']}, subcategory_id: ${match[0]['subcategory_id']}, sub_sub_category_id: ${match[0]['sub_sub_category_id']}");
        } else {
            print("No jumper products found in all_product.json");
        }
      }
    }
  } catch (e) {
    print("Error parsing json: $e");
  }
}
