import 'package:briio_application/screens/pages/categories/sub_subcategory_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/home_model.dart';
import '../../../utils/const.dart';
import '../../../utils/globel_veriable.dart';
import '../../home/api_services.dart';
import '../../../classes/categories.dart';
import '../../../model/catogries_model.dart';

class SubCategory extends StatefulWidget {
  const SubCategory(
      {super.key, required this.categoryId, required this.categoryName});

  final int categoryId;
  final String categoryName;

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  List<SubCategories> subCategory = [];
  List<Data> allCategories = [];

  bool isReady = false;
  late int currentCategoryId;
  late String currentCategoryName;
  final Map<int, GlobalKey> _categoryKeys = {};

  void _scrollToSelected() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_categoryKeys.containsKey(currentCategoryId) && _categoryKeys[currentCategoryId]?.currentContext != null) {
        Scrollable.ensureVisible(
          _categoryKeys[currentCategoryId]!.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.5,
        );
      }
    });
  }

  _getCategoriesAndSubCategories() async {
    setState(() {
      isReady = true;
    });
    try {
      final categoriesModel = await CategoriesView.getPro();
      if (categoriesModel.data != null) {
        allCategories = categoriesModel.data!;
        for (var sibling in allCategories) {
          final id = sibling.id ?? 0;
          _categoryKeys[id] = GlobalKey();
        }
      }

      final result = await ApiServices().getSubCategory(currentCategoryId);
      
      if (result.isEmpty) {
        setState(() {
          subCategory = [];
          isReady = false;
        });
        return;
      }

      setState(() {
        subCategory = result;
        isReady = false;
      });
      _scrollToSelected();
    } catch (e) {
      setState(() {
        isReady = false;
      });
      print(e);
    }
  }

  _getSubCategory(int id) async {
    setState(() {
      isReady = true;
    });
    try {
      final result = await ApiServices().getSubCategory(id);
      
      if (result.isEmpty) {
        setState(() {
          subCategory = [];
          isReady = false;
        });
        return;
      }

      setState(() {
        subCategory = result;
        isReady = false;
      });
    } catch (e) {
      setState(() {
        isReady = false;
      });
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    currentCategoryId = widget.categoryId;
    currentCategoryName = widget.categoryName;
    _getCategoriesAndSubCategories();
  }

  Widget _buildOptimizedImage(String imageUrl) {
    imageUrl = imageUrl.replaceAll(' ', '%20');
    if (imageUrl == "${imgPath}subcategory/" || imageUrl.isEmpty) {
      return Container(
        height: 170,
        width: double.infinity,
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: 170,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 170,
          width: double.infinity,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: 170,
        width: double.infinity,
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
      memCacheWidth: 512, // Optimize memory cache size
      memCacheHeight: 512,
      cacheKey: imageUrl,
      cacheManager: DefaultCacheManager(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        clipBehavior: Clip.none,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new,size: 18,color: Colors.grey.shade700,)),
        backgroundColor: Colors.white,
        title: Text(currentCategoryName,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: Column(
        children: [

          Expanded(
            child: isReady
                ? const Center(child: CircularProgressIndicator())
                : subCategory.isEmpty
                    ? const Center(child: Text("No subcategories found."))
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: subCategory.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                GlobalK.categoryId = currentCategoryId.toString();
                              });
                              Get.to(
                                () => SubSubCategoryScreen(
                                  categoryId: currentCategoryId,
                                  subCategoryId: subCategory[index].id!,
                                  subCategoryName: subCategory[index].subcategory!,
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildOptimizedImage(
                                    (subCategory[index].image != null && subCategory[index].image.toString().startsWith('http'))
                                        ? subCategory[index].image.toString()
                                        : "${imgPath}subcategory/${subCategory[index].image ?? ''}",
                                  ),
                                  Text(subCategory[index].subcategory.toString())
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
