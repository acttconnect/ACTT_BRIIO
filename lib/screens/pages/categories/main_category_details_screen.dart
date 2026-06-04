import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/home_model.dart';
import '../../../utils/const.dart';
import '../../../utils/globel_veriable.dart';
import 'subCategory.dart';

class MainCategoryDetailsScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const MainCategoryDetailsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<MainCategoryDetailsScreen> createState() => _MainCategoryDetailsScreenState();
}

class _MainCategoryDetailsScreenState extends State<MainCategoryDetailsScreen> {
  bool _isLoading = true;
  List<Categorie> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategoryData();
  }

  Future<void> _fetchCategoryData() async {
    try {
      String uri = '${apiUrl}HomeData?main_category_id=${widget.categoryId}';
      var response = await http.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var homeData = Home2Model.fromJson(jsonResponse);
        if (homeData.categorie != null) {
          setState(() {
            _categories = homeData.categorie!;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.grey.shade700, size: 18),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.categoryName.toUpperCase().replaceAll(' JEWELLERY', ''),
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
              ? const Center(child: Text("No categories found."))
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return GestureDetector(
                        onTap: () {
                          GlobalK.categoryId = category.id?.toString();
                          Get.to(() => SubCategory(
                                categoryId: category.id ?? 0,
                                categoryName: category.name ?? 'Unknown',
                              ));
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                  child: Builder(
                                    builder: (context) {
                                      String imgUrl = category.image ?? '';
                                      if (imgUrl.isNotEmpty && !imgUrl.startsWith('http')) imgUrl = '${imgPath}category/$imgUrl';
                                      if (imgUrl.isEmpty || imgUrl == '${imgPath}category/') return Container(color: Colors.grey[200]);
                                      return CachedNetworkImage(
                                        imageUrl: imgUrl.replaceAll(' ', '%20'),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(color: Colors.white),
                                        ),
                                        errorWidget: (context, url, error) {
                                          if (imgUrl == "${imgPath}category/" || imgUrl.isEmpty) {
                                            return Container(
                                              color: Colors.grey[200],
                                              child: const Icon(Icons.broken_image, color: Colors.grey),
                                            );
                                          }
                                          return Container(
                                            color: Colors.grey[200],
                                            child: const Icon(Icons.broken_image, color: Colors.grey),
                                          );
                                        },
                                      );
                                    }
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  category.name ?? '',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
