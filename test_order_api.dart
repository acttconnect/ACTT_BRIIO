import 'package:http/http.dart' as http;

void main() async {
  var url = Uri.parse('https://briio.in/api/getOrderData');
  var response = await http.post(url, body: {'id': '1', 'user_id': '1'});
  print(response.body);
}
