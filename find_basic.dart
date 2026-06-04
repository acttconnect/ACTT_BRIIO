import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print("Fetching main categories...");
  var res = await http.get(Uri.parse('https://briio.in/api/Categorie'));
  var json = jsonDecode(res.body);
  var categories = json['data'];
  
  for (var cat in categories) {
    if (cat['name'].toString().toLowerCase().contains('basic')) {
      print("Found in categories: ${cat['name']}");
    }
    
    var subRes = await http.get(Uri.parse('https://briio.in/api/get-sub-sub-categories?category_id=${cat['id']}&sub_category_id=0'));
    var subJson = jsonDecode(subRes.body);
    if (subJson['data'] == null) continue;
    var subs = subJson['data'];
    
    for (var sub in subs) {
      if (sub['subcategory'].toString().toLowerCase().contains('basic')) {
        print("Found in sub categories: ${sub['subcategory']} (ID: ${sub['id']})");
      }
      
      var sub3Res = await http.get(Uri.parse('https://briio.in/api/get-sub-category-three?category_id=${cat['id']}&subcategory_id=${sub['id']}&sub_subcategory_id=0'));
      var sub3Json = jsonDecode(sub3Res.body);
      if (sub3Json['data'] == null) continue;
      var sub3s = sub3Json['data'];
      
      for (var sub3 in sub3s) {
        var name = sub3['name'] ?? sub3['subcategory'] ?? "";
        if (name.toString().toLowerCase().contains('basic')) {
          print("Found in sub category three: $name (ID: ${sub3['id']})");
          print("Type: ${sub3Json['type']}");
        }
        
        if (sub3Json['type'] == 'sub_category_three') {
            try {
              var sub4Res = await http.get(Uri.parse('https://briio.in/api/get-sub-category-four?subcategory_three_id=${sub3['id']}'));
              var sub4Json = jsonDecode(sub4Res.body);
              if (sub4Json['data'] != null) {
                for (var sub4 in sub4Json['data']) {
                  var name4 = sub4['name'] ?? sub4['subcategory'] ?? "";
                  if (name4.toString().toLowerCase().contains('basic')) {
                    print("Found in sub category four: $name4 (ID: ${sub4['id']})");
                    print("Type: ${sub4Json['type']}");
                  }
                }
              }
            } catch(e) {}
        }
      }
    }
  }
}
