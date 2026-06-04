import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'sub_category_three_screen.dart';
import 'product_screen.dart';
import '../../home/api_services.dart';
import '../../../utils/const.dart';
import 'package:google_fonts/google_fonts.dart';

class SubSubCategoryScreen extends StatefulWidget {
  final int categoryId;
  final int subCategoryId;
  final String subCategoryName;

  const SubSubCategoryScreen({
    super.key,
    required this.categoryId,
    required this.subCategoryId,
    required this.subCategoryName,
  });

  @override
  State<SubSubCategoryScreen> createState() => _SubSubCategoryScreenState();
}

class _SubSubCategoryScreenState extends State<SubSubCategoryScreen> {
  List<dynamic> subSubCategories = [];
  List<dynamic> allSubCategories = []; // Siblings (tabs)
  
  bool isLoading = true;
  late int currentSubCategoryId;
  late String currentSubCategoryName;
  final Map<int, GlobalKey> _categoryKeys = {};

  void _scrollToSelected() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_categoryKeys.containsKey(currentSubCategoryId) && _categoryKeys[currentSubCategoryId]?.currentContext != null) {
        Scrollable.ensureVisible(
          _categoryKeys[currentSubCategoryId]!.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.5,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    currentSubCategoryId = widget.subCategoryId;
    currentSubCategoryName = widget.subCategoryName;
    _fetchSubCategoriesAndGrid();
  }

  Future<void> _fetchSubCategoriesAndGrid() async {
    setState(() {
      isLoading = true;
    });
    try {
      final siblingsResult = await ApiServices().getSubCategory(widget.categoryId);
      allSubCategories = siblingsResult;
      for (var sibling in allSubCategories) {
        final id = sibling.id ?? 0;
        _categoryKeys[id] = GlobalKey();
      }

      final result = await ApiServices().getSubSubCategory(widget.categoryId, currentSubCategoryId);
      
      if (result.isEmpty) {
        Get.off(() => ProductScreen(
          categoryId: widget.categoryId,
          subcategoryId: currentSubCategoryId,
          subcategoryName: currentSubCategoryName,
        ));
        return;
      }

      setState(() {
        subSubCategories = result;
        isLoading = false;
      });
      _scrollToSelected();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  Future<void> _fetchGridData(int id) async {
    setState(() {
      isLoading = true;
    });
    try {
      final result = await ApiServices().getSubSubCategory(widget.categoryId, id);
      
      if (result.isEmpty) {
        Get.off(() => ProductScreen(
          categoryId: widget.categoryId,
          subcategoryId: id,
          subcategoryName: currentSubCategoryName,
        ));
        return;
      }

      setState(() {
        subSubCategories = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          currentSubCategoryName,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : subSubCategories.isEmpty
                    ? const Center(child: Text("No data found."))
                    : Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: subSubCategories.length,
                          itemBuilder: (context, index) {
                            final item = subSubCategories[index];
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => SubCategoryThreeScreen(
                                  categoryId: widget.categoryId,
                                  subCategoryId: currentSubCategoryId,
                                  subSubCategoryId: item['id'],
                                  subSubCategoryName: item['name'] ?? item['subcategory'] ?? "Categories",
                                ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                        child: Builder(
                                          builder: (context) {
                                            String imgUrl = (item['image'] != null && item['image'].toString().startsWith('http'))
                                                ? item['image'].toString()
                                                : "${imgPath}subsubcategory/${item['image'] ?? ''}";
                                            imgUrl = imgUrl.replaceAll(' ', '%20');
                                            if (imgUrl == "${imgPath}subsubcategory/" || imgUrl.isEmpty) {
                                              return Container(
                                                color: Colors.grey[200],
                                                child: const Icon(Icons.broken_image, color: Colors.grey),
                                              );
                                            }
                                            return CachedNetworkImage(
                                              imageUrl: imgUrl,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor: Colors.grey[100]!,
                                                child: Container(color: Colors.white),
                                              ),
                                              errorWidget: (context, url, error) => Container(
                                                color: Colors.grey[200],
                                                child: const Icon(Icons.broken_image, color: Colors.grey),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        item['name'] ?? item['subcategory'] ?? '',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
