import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final url = 'https://briio.in/api/HomeData';
  final response = await http.get(Uri.parse(url));
  final Map<String, dynamic> data = json.decode(response.body);
  print('Keys: ${data.keys}');
  
  // also check site settings or something similar
  if (data.containsKey('logo')) {
    print('logo: ${data['logo']}');
  }
  if (data.containsKey('bis')) {
    print('bis: ${data['bis']}');
  }
}
