import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'sub_category_four_screen.dart';
import 'product_screen.dart';
import '../../home/api_services.dart';
import '../../../utils/const.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/globel_veriable.dart';

import 'package:briio_application/screens/home/product_detail_page.dart';
import '../../../model/get_category_id_by_product_model.dart';
import 'filter_page.dart';
import '../../../utils/pdf_generator.dart';

class SubCategoryThreeScreen extends StatefulWidget {
  final int categoryId;
  final int subCategoryId;
  final int subSubCategoryId;
  final String subSubCategoryName;

  const SubCategoryThreeScreen({
    super.key,
    required this.categoryId,
    required this.subCategoryId,
    required this.subSubCategoryId,
    required this.subSubCategoryName,
  });

  @override
  State<SubCategoryThreeScreen> createState() => _SubCategoryThreeScreenState();
}

class _SubCategoryThreeScreenState extends State<SubCategoryThreeScreen> {
  List<dynamic> allSubSubCategories = []; // Siblings (Tabs)
  List<dynamic> subCategoryThreeList = []; // Children (Grid)
  List<Product> productList = []; // Products for this level
  List<Product> allProductsList = []; // Unfiltered products

  bool isSelectMode = false;
  Set<int> selectedProductIds = {};
  Filters filters = Filters();
  String sortOrder = 'default';
  
  String currentDataType = "products";
  int currentSubSubCategoryId = 0;
  String currentSubSubCategoryName = "";
  
  bool isLoading = true;
  final Map<int, GlobalKey> _categoryKeys = {};

  void _scrollToSelected() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_categoryKeys.containsKey(currentSubSubCategoryId) && _categoryKeys[currentSubSubCategoryId]?.currentContext != null) {
        Scrollable.ensureVisible(
          _categoryKeys[currentSubSubCategoryId]!.currentContext!,
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
    filters = Filters();

    currentSubSubCategoryId = widget.subSubCategoryId;
    currentSubSubCategoryName = widget.subSubCategoryName;
    _fetchTabsAndGrid();
  }

  Future<void> _fetchTabsAndGrid() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Fetch siblings for tabs
      final siblings = await ApiServices().getSubSubCategory(widget.categoryId, widget.subCategoryId);
      allSubSubCategories = siblings;
      for (var sibling in allSubSubCategories) {
        final id = sibling['id'] ?? 0;
        _categoryKeys[id] = GlobalKey();
      }

      final result = await ApiServices().getSubCategoryThree(widget.categoryId, widget.subCategoryId, currentSubSubCategoryId);
      
      final subCategories = result['sub_category_three'] ?? [];
      final products = result['products'] ?? [];
      
      if (subCategories.isEmpty && products.isEmpty) {
        Get.off(() => ProductScreen(
          categoryId: widget.categoryId,
          subcategoryId: widget.subCategoryId,
          subSubCategoryId: currentSubSubCategoryId,
          subcategoryName: currentSubSubCategoryName,
        ));
        return;
      }

      setState(() {
        subCategoryThreeList = subCategories;
        allProductsList = List<Product>.from(products);
        filterProducts();
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
      final result = await ApiServices().getSubCategoryThree(widget.categoryId, widget.subCategoryId, id);
      
      final subCategories = result['sub_category_three'] ?? [];
      final products = result['products'] ?? [];
      
      if (subCategories.isEmpty && products.isEmpty) {
        Get.off(() => ProductScreen(
          categoryId: widget.categoryId,
          subcategoryId: widget.subCategoryId,
          subSubCategoryId: id,
          subcategoryName: currentSubSubCategoryName,
        ));
        return;
      }

      setState(() {
        subCategoryThreeList = subCategories;
        allProductsList = List<Product>.from(products);
        filterProducts();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  void filterProducts() {
    setState(() {
      productList = allProductsList.where((product) {
        return (product.gw ?? 0) >= filters.weightFrom &&
            (product.gw ?? 0) <= filters.weightTo;
      }).toList();
      if (sortOrder == 'lowToHigh') {
        productList.sort((a, b) => (a.gw ?? 0).compareTo(b.gw ?? 0));
      } else if (sortOrder == 'highToLow') {
        productList.sort((a, b) => (b.gw ?? 0).compareTo(a.gw ?? 0));
      }
    });
  }

  Widget _buildRadioTile(String title, int value, int groupValue, ValueChanged<int?> onChanged) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, color: Colors.black87)),
            Radio<int>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: const Color(0xFF5D5146),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          currentSubSubCategoryName,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (subCategoryThreeList.isNotEmpty)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.only(top: 24, bottom: 20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFFFFFF),
                                  Color(0xFFF5F7FA),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 4,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: Colors.black87,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Explore Categories",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),
                                SizedBox(
                                  height: 160,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    itemCount: subCategoryThreeList.length,
                                    itemBuilder: (context, index) {
                                      final item = subCategoryThreeList[index];
                                      
                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(() => SubCategoryFourScreen(
                                            categoryId: widget.categoryId,
                                            subCategoryId: widget.subCategoryId,
                                            subSubCategoryId: currentSubSubCategoryId,
                                            subCategoryThreeId: item['id'],
                                            subCategoryThreeName: item['name'] ?? item['subcategory'] ?? "Category",
                                            siblingCategories: subCategoryThreeList,
                                          ));
                                        },
                                        child: Container(
                                          width: 125,
                                          margin: const EdgeInsets.only(right: 16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(14),
                                            border: Border.all(color: Colors.grey.shade300, width: 2.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.06),
                                                blurRadius: 8,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(3),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                Builder(
                                                  builder: (context) {
                                                    String img = item['sub_cat_3_image'] ?? item['image'] ?? '';
                                                    String url = img.startsWith('http') ? img : "${imgPath}subcategory3/$img";
                                                    url = url.replaceAll(' ', '%20');
                                                    if (url == "${imgPath}subcategory3/" || url.isEmpty) {
                                                      return Container(color: Colors.grey[200]);
                                                    }
                                                    return CachedNetworkImage(
                                                      imageUrl: url,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) => Shimmer.fromColors(
                                                        baseColor: Colors.grey[300]!,
                                                        highlightColor: Colors.grey[100]!,
                                                        child: Container(color: Colors.white),
                                                      ),
                                                      errorWidget: (context, url, error) => Container(
                                                        color: Colors.grey[100],
                                                        child: const Icon(Icons.broken_image, color: Colors.grey, size: 24),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.transparent,
                                                        Colors.black.withOpacity(0.9)
                                                      ],
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      stops: const [0.5, 1.0],
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 12,
                                                  left: 4,
                                                  right: 4,
                                                  child: Text(
                                                    item['name'] ?? item['subcategory'] ?? '',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.white,
                                                      letterSpacing: 0.2,
                                                      height: 1.1,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                      if (productList.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                    ),
                                    builder: (context) {
                                      int selectedSort = sortOrder == 'default' ? 0 : (sortOrder == 'lowToHigh' ? 1 : 2);
                                      double minWeight = filters.weightFrom.toDouble();
                                      double maxWeight = filters.weightTo.toDouble();
                                      if (maxWeight <= minWeight) maxWeight = 200.0;

                                      return StatefulBuilder(
                                        builder: (BuildContext context, StateSetter setModalState) {
                                          return Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Sort & Filter',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(Icons.close, color: Colors.black54),
                                                      onPressed: () => Navigator.pop(context),
                                                    ),
                                                  ],
                                                ),
                                                const Divider(),
                                                const SizedBox(height: 10),
                                                const Text(
                                                  'Sort By',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                _buildRadioTile('Default', 0, selectedSort, (val) {
                                                  setModalState(() => selectedSort = val!);
                                                }),
                                                _buildRadioTile('Weight: Low to High', 1, selectedSort, (val) {
                                                  setModalState(() => selectedSort = val!);
                                                }),
                                                _buildRadioTile('Weight: High to Low', 2, selectedSort, (val) {
                                                  setModalState(() => selectedSort = val!);
                                                }),
                                                const SizedBox(height: 20),
                                                const Divider(),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Weight Range (g)',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${minWeight.toInt()} - ${maxWeight.toInt()}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                RangeSlider(
                                                  values: RangeValues(minWeight, maxWeight),
                                                  min: 0,
                                                  max: 1000,
                                                  activeColor: const Color(0xFF5D5146),
                                                  inactiveColor: Colors.grey.shade300,
                                                  onChanged: (RangeValues values) {
                                                    setModalState(() {
                                                      minWeight = values.start;
                                                      maxWeight = values.end;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(height: 30),
                                                SizedBox(
                                                  width: double.infinity,
                                                  height: 50,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color(0xFF5D5146),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        if (selectedSort == 0) {
                                                          sortOrder = 'default';
                                                        } else if (selectedSort == 1) {
                                                          sortOrder = 'lowToHigh';
                                                        } else if (selectedSort == 2) {
                                                          sortOrder = 'highToLow';
                                                        }
                                                        filters = filters.copyWith(
                                                          weightFrom: minWeight.toInt(),
                                                          weightTo: maxWeight.toInt(),
                                                        );
                                                        filterProducts();
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'Apply',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                              ],
                                            ),
                                          );
                                        }
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.sort, color: Colors.black87),
                                label: const Text('Sort', style: TextStyle(color: Colors.black87)),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isSelectMode = !isSelectMode;
                                    if (!isSelectMode) {
                                      selectedProductIds.clear();
                                    }
                                  });
                                },
                                child: Text(
                                  isSelectMode ? 'Cancel' : 'Select',
                                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: productList.length,
                            itemBuilder: (context, index) {
                              final product = productList[index];
                              return Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (isSelectMode) {
                                        setState(() {
                                          if (selectedProductIds.contains(product.id)) {
                                            selectedProductIds.remove(product.id);
                                          } else {
                                            selectedProductIds.add(product.id!);
                                          }
                                        });
                                      } else {
                                        setState(() {
                                          GlobalK.productId = product.id?.toString() ?? '';
                                          GlobalK.productName = product.name?.toString() ?? '';
                                        });
                                        if (product.id != null) {
                                          Get.to(() => ProductDetailsPage(
                                                productId: product.id!,
                                              ));
                                        }
                                      }
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Builder(
                                            builder: (context) {
                                              String img = product.image ?? '';
                                              String url = img.startsWith('http') ? img : "${imgPath}products/$img";
                                              url = url.replaceAll(' ', '%20');
                                              if (url == "${imgPath}products/" || url.isEmpty) {
                                                return Expanded(child: Container(color: Colors.grey[200]));
                                              }
                                              return Expanded(
                                                child: CachedNetworkImage(
                                                  imageUrl: url,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => Shimmer.fromColors(
                                                    baseColor: Colors.grey[300]!,
                                                    highlightColor: Colors.grey[100]!,
                                                    child: Container(color: Colors.white),
                                                  ),
                                                  errorWidget: (context, url, error) => Container(color: Colors.grey[200], child: const Icon(Icons.broken_image, color: Colors.grey)),
                                                ),
                                              );
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  product.name ?? '',
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "Gross Wt: ${product.gw ?? '-'}",
                                                  style: const TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (isSelectMode)
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Checkbox(
                                        value: selectedProductIds.contains(product.id),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value == true) {
                                              selectedProductIds.add(product.id!);
                                            } else {
                                              selectedProductIds.remove(product.id);
                                            }
                                          });
                                        },
                                        activeColor: const Color(0xFF5D5146),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ] else if (subCategoryThreeList.isEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(child: Text("No data found.")),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
      floatingActionButton: isSelectMode && selectedProductIds.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                final selectedItems = allProductsList.where((p) => selectedProductIds.contains(p.id)).toList();
                await PdfGenerator.generateAndShowPdf(context, selectedItems, currentSubSubCategoryName);
              },
              backgroundColor: Colors.red.shade400,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.white, size: 24),
                  Text('PDF', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
