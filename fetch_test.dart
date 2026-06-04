import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  try {
    // We will query AllProduct to see at least one product's keys
    var request = http.Request('GET', Uri.parse('https://briio.in/api/AllProduct'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final rawData = await response.stream.bytesToString();
      final jsonData = jsonDecode(rawData);
      final List jsonProducts = jsonData['product'] ?? jsonData['data'] ?? [];
      if (jsonProducts.isNotEmpty) {
        print("Keys for a product from AllProduct:");
        print(jsonProducts[0].keys.toList());
        print("First product: ${jsonProducts[0]}");
      }
    } else {
      print("AllProduct failed. Trying ProductByCategorieId with category 7");
      var r2 = http.Request('GET', Uri.parse('https://briio.in/api/ProductByCategorieId?category_id=7'));
      var res2 = await r2.send();
      if (res2.statusCode == 200 || res2.statusCode == 201) {
        final raw2 = await res2.stream.bytesToString();
        final json2 = jsonDecode(raw2);
        final List p2 = json2['product'] ?? json2['data'] ?? [];
        if (p2.isNotEmpty) {
           print("Keys for a product from CategorieId 7:");
           print(p2[0].keys.toList());
           print("sub_sub_category_id is: ${p2[0]['sub_sub_category_id']}");
           print("sub_subcategory_id is: ${p2[0]['sub_subcategory_id']}");
        }
      }
    }
  } catch (e) {
    print(e);
  }
}
