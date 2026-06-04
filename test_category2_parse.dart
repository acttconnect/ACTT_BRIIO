import 'package:http/http.dart' as http;
import 'dart:convert';
import 'lib/model/catogries_model.dart';

void main() async {
  var url = Uri.parse('https://briio.in/api/Categorie');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    try {
      var data = jsonDecode(response.body);
      var model = CatogriesModel.fromJson(data);
      print('Parsed Categorie successfully: ${model.data?.length} categories');
    } catch (e, stacktrace) {
      print('Error parsing Categorie JSON: $e\n$stacktrace');
    }
  }
}
