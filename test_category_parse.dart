import 'package:http/http.dart' as http;
import 'dart:convert';
import 'lib/model/main_category_model.dart';

void main() async {
  var url = Uri.parse('https://briio.in/api/get-main-categories');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    try {
      var data = jsonDecode(response.body);
      var model = MainCategoryModel.fromJson(data);
      print('Parsed successfully: ${model.data?.length} categories');
    } catch (e, stacktrace) {
      print('Error parsing JSON: $e\n$stacktrace');
    }
  }
}
