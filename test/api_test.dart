import 'package:flutter_test/flutter_test.dart';
import 'package:briio_application/screens/home/api_services.dart';

void main() {
  test('Test ApiServices getProductsBySubCategoryFour', () async {
    try {
      var products = await ApiServices().getProductsBySubCategoryFour(12);
      print("Success: ${products.length} products fetched and parsed.");
    } catch (e, stackTrace) {
      print("Exception fetching or parsing product: $e");
      print(stackTrace);
    }
  });
}
