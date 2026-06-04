import 'package:http/http.dart' as http;

void main() async {
  final url = 'https://briio.in/api/HomeData';
  final response = await http.get(Uri.parse(url));
  print(response.body);
}
