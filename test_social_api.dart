import 'package:http/http.dart' as http;

void main() async {
  var urls = [
    'https://briio.in/api/settings',
    'https://briio.in/api/social',
    'https://briio.in/api/pages',
    'https://briio.in/api/get-settings',
    'https://briio.in/api/company_info',
  ];
  for (var url in urls) {
    try {
      var res = await http.get(Uri.parse(url));
      print('URL: $url, Status: ${res.statusCode}, Body: ${res.body.length > 100 ? '${res.body.substring(0, 100)}...' : res.body}');
    } catch(e) {
      print('URL: $url Error: $e');
    }
  }
}
