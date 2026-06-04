import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/get_category_id_by_product_model.dart';
import '../../model/background_image.dart';
import '../../model/get_new_cart_model.dart';
import '../../model/home_model.dart';
import '../../model/main_category_model.dart';
import '../../utils/api_endpoints.dart';
import '../../utils/const.dart';
import '../../utils/globel_veriable.dart';

class ApiServices {
  Future<MainCategoryModel?> getMainCategories() async {
    try {
      var response =
          await http.get(Uri.parse("${apiUrl}get-main-categories"));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return MainCategoryModel.fromJson(data);
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
  Future<List<BackImage>?> getBgImage() async {
    try {
      var response =
          await http.get(Uri.parse(ApiEndpoints.categories));
      if (response.statusCode == 200) {
        final models = List.from(jsonDecode(response.body)['data'])
            .map((e) => BackImage.fromJson(e))
            .toList();
        return models;
      }
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<List<SubCategories>> getSubCategory(int categoryId) async {
    try {
      String url = '${ApiEndpoints.subCategories}?category_id=$categoryId';
      if (GlobalK.mainCategoryId != null) {
        url += '&main_category_id=${GlobalK.mainCategoryId}';
      }
      var request = http.Request('GET', Uri.parse(url));
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(await response.stream.bytesToString());
        final list = List.from(data['data']);
        return list.map((e) => SubCategories.fromJson(e)).toList();
      } else {
        throw "An error occurred: ${response.reasonPhrase}";
      }
    } catch (e) {
      throw "An error occurred: $e";
    }
  }

  Future<List<dynamic>> getSubSubCategory(int categoryId, int subCategoryId) async {
    try {
      String url = '${apiUrl}get-sub-sub-categories?category_id=$categoryId&sub_category_id=$subCategoryId';
      if (GlobalK.mainCategoryId != null) {
        url += '&main_category_id=${GlobalK.mainCategoryId}';
      }
      var request = http.Request('GET', Uri.parse(url));
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(await response.stream.bytesToString());
        return List.from(data['data'] ?? []);
      } else {
        throw "An error occurred: ${response.reasonPhrase}";
      }
    } catch (e) {
      throw "An error occurred: $e";
    }
  }

  Future<List<Product>> getProducts(int subCategoryId, int categoryId) async {
    try {
      var request = http.Request(
          'GET',
          Uri.parse('${ApiEndpoints.productBySubCategoryId}?id=$subCategoryId&category_id=$categoryId'));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final rawData = await response.stream.bytesToString();
        print('=== PRODUCT RAW DATA ===');
        print(rawData);
        final jsonData = jsonDecode(rawData);
        final List jsonProducts = jsonData['product'] ?? jsonData['data'] ?? [];
        final result = jsonProducts.map((e) => Product.fromJson(e)).toList();
        return result;
      } else {
        throw "An error occurred: ${response.reasonPhrase}";
      }
    } catch (e) {
      throw "An error occurred: $e";
    }
  }

  Future<Map<String, dynamic>> getSubCategoryThree(int categoryId, int subCategoryId, int subSubCategoryId) async {
    try {
      String url = '${apiUrl}get-sub-category-three?category_id=$categoryId&subcategory_id=$subCategoryId&sub_subcategory_id=$subSubCategoryId';
      if (GlobalK.mainCategoryId != null) {
        url += '&main_category_id=${GlobalK.mainCategoryId}';
      }
      var request = http.Request('GET', Uri.parse(url));
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(await response.stream.bytesToString());
        
        List<dynamic> subCat3 = [];
        List<dynamic> prods = [];
        
        if (data.containsKey('sub_category_three') || data.containsKey('products') || data.containsKey('product')) {
           subCat3 = List.from(data['sub_category_three'] ?? []);
           prods = List.from(data['products'] ?? data['product'] ?? []);
        } else if (data['type'] == 'products') {
           prods = List.from(data['data'] ?? []);
        } else {
           subCat3 = List.from(data['data'] ?? []); 
        }

        return {
          'sub_category_three': subCat3,
          'products': prods.map((e) => Product.fromJson(e)).toList(),
        };
      } else {
        throw "An error occurred: ${response.reasonPhrase}";
      }
    } catch (e) {
      throw "An error occurred: $e";
    }
  }

  Future<Map<String, dynamic>> getSubCategoryThreeWithType(int categoryId, int subCategoryId, int subSubCategoryId) async {
    try {
      var request = http.Request('GET', Uri.parse('${ApiEndpoints.subCategoryThree}?main_category_id=1&category_id=$categoryId&subcategory_id=$subCategoryId&sub_subcategory_id=$subSubCategoryId'));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String rawData = await response.stream.bytesToString();
        var jsonResponse = json.decode(rawData);
        if (jsonResponse['error'] == false) {
           return {
             'type': jsonResponse['type'],
             'data': jsonResponse['data'] ?? []
           };
        }
      }
      return {'type': 'error', 'data': []};
    } catch (e) {
      print(e);
      return {'type': 'error', 'data': []};
    }
  }

  Future<Map<String, dynamic>> getSubCategoryFourWithType(int subCategoryThreeId) async {
    try {
      var request = http.Request('GET', Uri.parse('${ApiEndpoints.subCategoryFour}?subcategory_three_id=$subCategoryThreeId'));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String rawData = await response.stream.bytesToString();
        var jsonResponse = json.decode(rawData);
        if (jsonResponse['error'] == false) {
           return {
             'type': jsonResponse['type'],
             'data': jsonResponse['data'] ?? []
           };
        }
      }
      return {'type': 'error', 'data': []};
    } catch (e) {
      print(e);
      return {'type': 'error', 'data': []};
    }
  }

  Future<List<Product>> getProductsBySubCategoryThree(int subCategoryThreeId) async {
    try {
      var request = http.Request('GET', Uri.parse('${ApiEndpoints.subCategoryFour}?subcategory_three_id=$subCategoryThreeId'));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String rawData = await response.stream.bytesToString();
        var jsonResponse = json.decode(rawData);
        
        List<dynamic> data = jsonResponse['products'] ?? jsonResponse['product'] ?? jsonResponse['data'] ?? [];
        
        return data.map((e) => Product.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Product>> getProductsBySubSubCategory(int categoryId, int subCategoryId, int subSubCategoryId) async {
    try {
      String url = '${ApiEndpoints.subCategoryThree}?category_id=$categoryId&subcategory_id=$subCategoryId&sub_subcategory_id=$subSubCategoryId';
      if (GlobalK.mainCategoryId != null) {
        url += '&main_category_id=${GlobalK.mainCategoryId}';
      }
      var request = http.Request('GET', Uri.parse(url));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        String rawData = await response.stream.bytesToString();
        var jsonResponse = json.decode(rawData);
        
        List<dynamic> data = jsonResponse['products'] ?? jsonResponse['product'] ?? jsonResponse['data'] ?? [];
        
        return data.map((e) => Product.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Map<String, dynamic>> getSubCategoryFour(int subCategoryThreeId) async {
    try {
      String url = '${apiUrl}get-sub-category-four?subcategory_three_id=$subCategoryThreeId';
      var request = http.Request('GET', Uri.parse(url));
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(await response.stream.bytesToString());
        
        List<dynamic> subCat4 = [];
        List<Product> prods = [];
        
        if (data.containsKey('sub_category_four') || data.containsKey('products') || data.containsKey('product')) {
           subCat4 = List.from(data['sub_category_four'] ?? []);
           final rawProds = List.from(data['products'] ?? data['product'] ?? []);
           prods = rawProds.map((e) => Product.fromJson(e)).toList();
        } else if (data['type'] == 'products') {
           final rawProds = List.from(data['data'] ?? []);
           prods = rawProds.map((e) => Product.fromJson(e)).toList();
        } else if (data['type'] == 'sub_category_four' || data['type'] == 'sub_category') {
           subCat4 = List.from(data['data'] ?? []);
        } else {
           subCat4 = List.from(data['data'] ?? []); 
        }

        return {
          'sub_category_four': subCat4,
          'products': prods
        };
      } else {
        throw "An error occurred: ${response.reasonPhrase}";
      }
    } catch (e) {
      throw "An error occurred: $e";
    }
  }

  Future<List<dynamic>> getProductsBySubCategoryFour(int subCategoryFourId) async {
    try {
      var request = http.Request(
          'GET',
          Uri.parse('${apiUrl}get-products-by-sub-category-four?subcategory_four_id=$subCategoryFourId'));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final rawData = await response.stream.bytesToString();
        final jsonData = jsonDecode(rawData);
        final List jsonProducts = jsonData['product'] ?? jsonData['data'] ?? [];
        return jsonProducts;
      } else {
        throw "An error occurred: ${response.reasonPhrase}";
      }
    } catch (e) {
      throw "An error occurred: $e";
    }
  }

  Future<List<GetNewCartModel>?> getCard() async {
    try {
      var request = http.Request('GET',
          Uri.parse('${ApiEndpoints.getCart}?userid=${GlobalK.userId}'));
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final rawData = await response.stream.bytesToString();
        final jsonData = jsonDecode(rawData);
        final List jsonCart = jsonData['data'] ?? [];
        final result = jsonCart.map((item) => GetNewCartModel.fromJson(item as Map<String, dynamic>)).toList();
        return result;
      } else {
        throw "An error occurred: ${response.reasonPhrase}";
      }
    } catch (e) {
      throw "An error occurred: $e";
    }
  }
}
