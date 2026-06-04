import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  try {
    var r1 = await http.get(Uri.parse('https://briio.in/api/getUserData?user_id=1'));
    print('r1: ${r1.statusCode} ${r1.body}');
  } catch(e){}
  try {
    var r2 = await http.get(Uri.parse('https://briio.in/api/getProfile?user_id=1'));
    print('r2: ${r2.statusCode} ${r2.body}');
  } catch(e){}
  try {
    var r3 = await http.get(Uri.parse('https://briio.in/api/getUser?user_id=1'));
    print('r3: ${r3.statusCode} ${r3.body}');
  } catch(e){}
}
