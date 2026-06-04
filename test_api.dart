import 'package:http/http.dart' as http;
void main() async {
  var res = await http.get(Uri.parse('https://briio.in/api/Categorie'));
  print(res.body);
}
