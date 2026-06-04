import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  var url1 = Uri.parse('https://briio.in/api/Categorie');
  var response1 = await http.get(url1);
  print('Categorie: ${response1.statusCode} - ${response1.body.length} bytes');
  if (response1.statusCode == 200) print(response1.body);

  var url2 = Uri.parse('https://briio.in/api/get-main-categories');
  var response2 = await http.get(url2);
  print('get-main-categories: ${response2.statusCode} - ${response2.body.length} bytes');
  if (response2.statusCode == 200) print(response2.body);
}
