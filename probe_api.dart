import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  List<String> endpoints = [
    'SubscriptionPlans',
    'Plans',
    'Membership',
    'getPlans',
    'getMembership',
    'subscriptions',
    'memberships',
    'getSubscriptionData'
  ];

  for (var endpoint in endpoints) {
    try {
      var res = await http.get(Uri.parse('https://briio.in/api/$endpoint'));
      if (res.statusCode == 200 || res.statusCode == 201) {
        print('SUCCESS: $endpoint -> ${res.body.substring(0, res.body.length > 200 ? 200 : res.body.length)}');
      } else {
        print('FAILED: $endpoint -> ${res.statusCode}');
      }
    } catch (e) {
      print('ERROR: $endpoint -> $e');
    }
  }
}
