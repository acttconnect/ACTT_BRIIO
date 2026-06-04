import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../model/catogries_model.dart';
import '../../utils/const.dart';
import '../../widgets/big_text.dart';
import 'catogriesbyproduct.dart';

class CatogreisPage extends StatefulWidget {
  const CatogreisPage({super.key});

  @override
  State<CatogreisPage> createState() => _CatogreisPageState();
}

Future<CatogriesModel> getPro() async {
  try {
    final response = await http.get(Uri.parse('${apiUrl}Categorie'));

    print('API Response Status: ${response.statusCode}');
    print('API Response Body: ${response.body}');

    // Check if response is HTML (error page)
    if (response.body.trim().startsWith('<') || response.body.trim().startsWith('<!')) {
      throw Exception('Server returned HTML instead of JSON. Status: ${response.statusCode}');
    }

    // Check status code first
    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode} - ${response.body}');
    }

    var data = jsonDecode(response.body);
    return CatogriesModel.fromJson(data);
  } catch (e) {
    print('Error in getPro(): $e');
    rethrow;
  }
}

class _CatogreisPageState extends State<CatogreisPage> {
  late Future<CatogriesModel> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    // Cache the future so it's not called on every rebuild
    _categoriesFuture = getPro();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<CatogriesModel>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading state
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            // Show error state
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.data == null || snapshot.data!.data!.isEmpty) {
            // Show empty state
            return const Center(
              child: Text('No categories available'),
            );
          }

          final categories = snapshot.data!.data!;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () async {
                  String? name = category.name?.toString();
                  String? id = category.id?.toString();
                  if (name != null && id != null) {
                    await Get.to(() => CatogriesByProduct(
                          catogiresId: id,
                          catoriesName: name,
                        ));
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(20),
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white70,
                      ),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.error),
                        ),
                        imageUrl: '${imgPath}category/${category.image.toString()}',
                        fit: BoxFit.cover,
                      ),
                    ),
                    BigText(
                      text: category.name?.toString() ?? 'Unknown',
                      size: 13,
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
