import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';
import '../../home/api_services.dart';
import '../../../model/get_category_id_by_product_model.dart';
import '../../../utils/const.dart';
import '../../../utils/globel_veriable.dart';
import 'package:briio_application/screens/home/product_detail_page.dart';
import 'package:briio_application/screens/pages/categories/filter_page.dart';
import '../../../utils/pdf_generator.dart';
import 'package:briio_application/classes/wishlist.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductScreen extends StatefulWidget {
  final int categoryId;
  final int subcategoryId;
  final int? subSubCategoryId;
  final int? subCategoryThreeId;
  final int? subCategoryFourId;
  final String subcategoryName;
  final List<dynamic>? preloadedProducts;
  final List<dynamic>? siblingCategories;

  const ProductScreen({
    super.key,
    required this.categoryId,
    required this.subcategoryId,
    this.subSubCategoryId,
    this.subCategoryThreeId,
    this.subCategoryFourId,
    required this.subcategoryName,
    this.preloadedProducts,
    this.siblingCategories,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> products = [];
  List<Product> allProducts = [];
  List<dynamic> localSiblingCategories = [];
  final Map<int, GlobalKey> _categoryKeys = {};
  bool isReady = true;
  bool isLoader = false;
  bool isLoading = true;
  Set<int> wishlistedProducts = {};
  Filters filters = Filters();
  String sortOrder = 'default';

  bool isSelectMode = false;
  Set<int> selectedProductIds = {};

  late int? currentSubcategoryId;
  late int? currentSubSubCategoryId;
  late int? currentSubCategoryThreeId;
  late int? currentSubCategoryFourId;
  late String currentSubcategoryName;

  _getProducts() async {
    setState(() {
      isReady = true;
    });
    try {
      List<Product> result = [];
      // If we have preloaded products on the first load, parse them directly
      if (widget.preloadedProducts != null && allProducts.isEmpty && products.isEmpty) {
        result = widget.preloadedProducts!.map((e) => Product.fromJson(e)).toList();
      } else {
        if (currentSubCategoryFourId != null) {
          final rawData = await ApiServices().getProductsBySubCategoryFour(currentSubCategoryFourId!);
          result = rawData.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
        } else if (currentSubCategoryThreeId != null) {
          result = await ApiServices().getProductsBySubCategoryThree(currentSubCategoryThreeId!);
        } else if (currentSubSubCategoryId != null) {
          result = await ApiServices().getProductsBySubSubCategory(widget.categoryId, currentSubcategoryId ?? 0, currentSubSubCategoryId!);
        } else {
          result = await ApiServices().getProducts(currentSubcategoryId ?? 0, widget.categoryId);
        }
      }
      
      setState(() {
        products = result;
        allProducts = result;
        isReady = false;
      });
    } catch (e) {
      setState(() {
        isReady = false;
      });
      print(e);
    }
  }

  void filterProducts() {
    setState(() {
      products = List.from(allProducts);
      
      products = products.where((product) {
        final weight = product.gw ?? 0;
        return weight >= filters.weightFrom && weight <= filters.weightTo;
      }).toList();

      if (sortOrder == 'lowToHigh') {
        products.sort((a, b) => (a.gw ?? 0).compareTo(b.gw ?? 0));
      } else if (sortOrder == 'highToLow') {
        products.sort((a, b) => (b.gw ?? 0).compareTo(a.gw ?? 0));
      }
    });
  }

  void sortProducts(String order) {
    setState(() {
      sortOrder = order;
      if (order == 'lowToHigh') {
        products.sort((a, b) => (a.gw ?? 0).compareTo(b.gw ?? 0));
      } else if (order == 'highToLow') {
        products.sort((a, b) => (b.gw ?? 0).compareTo(a.gw ?? 0));
      }
    });
  }

  Future<void> _loadWishlistedProducts() async {
    final wishlistData = await Wishlist.getWishlist();
    setState(() {
      wishlistedProducts = wishlistData.data
          ?.map((item) => int.parse(item.productid.toString()))
          .toSet() ?? {};
    });
  }

  @override
  void initState() {
    super.initState();
    currentSubcategoryId = widget.subcategoryId;
    currentSubSubCategoryId = widget.subSubCategoryId;
    currentSubCategoryThreeId = widget.subCategoryThreeId;
    currentSubCategoryFourId = widget.subCategoryFourId;
    currentSubcategoryName = widget.subcategoryName;
    filters = Filters();

    if (widget.siblingCategories != null) {
      localSiblingCategories = List.from(widget.siblingCategories!);
      for (var sibling in localSiblingCategories) {
        final id = sibling['id'] is int ? sibling['id'] : int.tryParse(sibling['id'].toString()) ?? 0;
        _categoryKeys[id] = GlobalKey();
      }
    }

    _getProducts();
    _loadWishlistedProducts();
    _scrollToSelected();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if(mounted) {
        setState(() {
          isLoading = false;
          isLoader = true;
        });
      }
    });
  }

  void _scrollToSelected() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int selectedId = currentSubCategoryFourId ?? currentSubCategoryThreeId ?? currentSubSubCategoryId ?? currentSubcategoryId ?? 0;
      if (_categoryKeys.containsKey(selectedId) && _categoryKeys[selectedId]?.currentContext != null) {
        Scrollable.ensureVisible(
          _categoryKeys[selectedId]!.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.5,
        );
      }
    });
  }

  Widget _buildImageWithShimmer(String imageUrl) {
    if (imageUrl == "${imgPath}products/" || imageUrl.isEmpty) {
      return Container(
        height: 160,
        width: double.infinity,
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: 160,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 160,
          width: double.infinity,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      memCacheWidth: 512,
      memCacheHeight: 512,
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
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey.shade700,
            size: 18,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          currentSubcategoryName.toUpperCase(),
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [

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
          Expanded(
            child: isReady
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty 
                    ? const Center(child: Text("No Products found."))
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (isSelectMode) {
                                    setState(() {
                                      if (selectedProductIds.contains(products[index].id)) {
                                        selectedProductIds.remove(products[index].id);
                                      } else {
                                        selectedProductIds.add(products[index].id!);
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      GlobalK.productId =
                                          products[index].id?.toString() ?? '';
                                      GlobalK.productName =
                                          products[index].name?.toString() ?? '';
                                    });
                                    if (products[index].id != null) {
                                      Get.to(() => ProductDetailsPage(
                                            productId: products[index].id!,
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
                                          String img = products[index].image ?? '';
                                          String url = img.startsWith('http') ? img : "${imgPath}products/$img";
                                          url = url.replaceAll(' ', '%20');
                                          return _buildImageWithShimmer(url);
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              products[index].name?.toString() ?? '',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              "Gross wt: ${products[index].gw?.toString() ?? '-'}",
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 5),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 16,
                                right: 16,
                                child: GestureDetector(
                                  onTap: () async {
                                    final productId = products[index].id.toString();
                                    if (wishlistedProducts.contains(products[index].id)) {
                                      await Wishlist.getDeleteWishlist(
                                        product_id: productId,
                                        productVarientId: '6',
                                      );
                                      setState(() {
                                        wishlistedProducts.remove(products[index].id);
                                      });
                                    } else {
                                      await Wishlist.getAddWishlist(
                                        product_id: productId,
                                        productVarientId: '6',
                                      );
                                      setState(() {
                                        if (products[index].id != null) {
                                          wishlistedProducts.add(products[index].id!);
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      wishlistedProducts.contains(products[index].id)
                                          ? Icons.favorite
                                          : Icons.favorite_border_outlined,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              if (isSelectMode)
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Checkbox(
                                    value: selectedProductIds.contains(products[index].id),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedProductIds.add(products[index].id!);
                                        } else {
                                          selectedProductIds.remove(products[index].id);
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
        ],
      ),
      floatingActionButton: isSelectMode && selectedProductIds.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                final selectedItems = allProducts.where((p) => selectedProductIds.contains(p.id)).toList();
                await PdfGenerator.generateAndShowPdf(context, selectedItems, widget.subcategoryName);
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

  Widget _buildRadioTile(String title, int value, int groupValue, ValueChanged<int?> onChanged) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            Radio<int>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: const Color(0xFF5D5146), // Brown color
            ),
          ],
        ),
      ),
    );
  }
}
