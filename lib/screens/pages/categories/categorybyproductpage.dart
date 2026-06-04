// ignore_for_file: unnecessary_null_comparison
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../classes/whatsaap.dart';
import '../../../classes/wishlist.dart';
import '../../../model/get_category_id_by_product_model.dart';
import '../../../model/search_to.dart';
import '../../../utils/const.dart';
import '../../../utils/globel_veriable.dart';
import '../../home/product_detail_page.dart';
import 'filter_page.dart';

class CategoryByProduct extends StatefulWidget {
  const CategoryByProduct({super.key});

  @override
  State<CategoryByProduct> createState() => _CategoryByProductState();
}

class _CategoryByProductState extends State<CategoryByProduct> {
  get margin => null;
  bool isLoader = false;
  var count = 1;
  var count1 = 2;
  int? index1;
  int? indexPage;
  bool isSort = false;
  bool isReverse = false;

  bool isLoading = false;
  
  bool isSelectMode = false;
  Set<int> selectedProductIds = {};

  @override
  void initState() {
    super.initState();
    filters = Filters();
    initializeProducts();
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        isLoading = false;
        isLoader = true;
      });
    });
  }

  List<Product> products = [];

  void filterProducts() {
    setState(() {
      products = products.where((product) {
        return product.gw! >= filters.weightFrom &&
            product.gw! <= filters.weightTo;
      }).toList();
    });
    setState(() {});
  }

  void initializeProducts() async {
    final result = await fetchProducts(isSort, isReverse);
    setState(() {
      products = result;
    });
  }

  Future<List<Product>> fetchProducts(bool sortOrNot, bool reverse) async {
    List<Product> product = [];
    final response = await http.post(
        Uri.parse('${apiUrl}ProductBySubCategorieId?id=${GlobalK.categoryId}'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var mainData = data['product'] ?? data['data'] ?? [];
      int length = mainData.length;
      for (int i = 0; i < length; i++) {
        product.add(Product.fromJson(mainData[i]));
      }
      if (sortOrNot) {
        product.sort((a, b) => a.nw!.compareTo(b.nw!));
      }
      if (reverse) {
        product.sort((a, b) => b.nw!.compareTo(a.nw!));
      }
      return product;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Searchto> getSearch() async {
    final response =
        await http.get(Uri.parse('${apiUrl}searchbycat/$selectSp'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return Searchto.fromJson(data);
    } else {
      return Searchto.fromJson(data);
    }
  }

  int? selectIndex;
  String? selectSp;

  late Filters filters;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Text(
          'Sub Category',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                            int selectedSort = isSort ? 1 : (isReverse ? 2 : 0);
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
                                        max: 1000, // Assuming 1000g max for now
                                        activeColor: const Color(0xFF5D5146), // Brown color from mockup
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
                                            backgroundColor: const Color(0xFF5D5146), // Brown color
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (selectedSort == 0) {
                                                isSort = false;
                                                isReverse = false;
                                              } else if (selectedSort == 1) {
                                                isSort = true;
                                                isReverse = false;
                                              } else if (selectedSort == 2) {
                                                isSort = false;
                                                isReverse = true;
                                              }
                                              filters = filters.copyWith(
                                                weightFrom: minWeight.toInt(),
                                                weightTo: maxWeight.toInt(),
                                              );
                                              filterProducts(); // Apply filters
                                              initializeProducts(); // Refresh sorting
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
                  ],
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
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          selectSp == null
              ? Expanded(child: Builder(
                  builder: (
                    context,
                  ) {
                    if (products == null || products.isEmpty) {
                      return const Center(
                        child: Text('No data available.'),
                      ); // No Data
                    }
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 250,
                                  mainAxisExtent: 250,
                                  childAspectRatio: 4 / 7,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: margin ?? EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    offset: Offset.zero,
                                    blurRadius: 15.0,
                                  )
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                fit: StackFit.expand,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        GlobalK.productId =
                                            '${products[index].id!.toString()} ';
                                        GlobalK.productName =
                                            '${products[index].name!.toString()} ';
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailsPage(
                                                  productId:
                                                      products[index].id!,
                                                )),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: CachedNetworkImage(
                                        imageUrl: products[index].image!.toString().startsWith('http') ? products[index].image!.toString() : '${imgPath}products/${products[index].image!.toString()}',
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            const Center(child: Icon(Icons.image_not_supported)),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 16,
                                    right: 16,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() async {
                                          await Wishlist.getAddWishlist(
                                              product_id:
                                                  products[index]
                                                      .id
                                                      .toString(),
                                              productVarientId: '6');
                                        });
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.favorite_border_outlined,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          products[index].name?.toString() ?? '',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  },
                ))
              : Expanded(
                  child: FutureBuilder<Searchto>(
                  future: getSearch(),
                  builder: (context, snapshot) => snapshot.hasData
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 250,
                                      childAspectRatio: 4 / 7,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8),
                              itemCount: products.length,
                              itemBuilder: (context, index) => Container(
                                    margin: margin ?? EdgeInsets.zero,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          offset: Offset.zero,
                                          blurRadius: 15.0,
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Stack(
                                            alignment: Alignment.center,
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
                                                          '${products[index].id!.toString()} ';
                                                      GlobalK.productName =
                                                          '${products[index].name!.toString()} ';
                                                    });
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetailsPage(
                                                                productId:
                                                                    products[
                                                                            index]
                                                                        .id!,
                                                              )),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 5),
                                                  height: 200,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      image: NetworkImage(
                                                        products[index].image!.toString().startsWith('http') ? products[index].image!.toString() : '${imgPath}products/${products[index].image!.toString()}',
                                                      ),
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
                                                    activeColor: Colors.amber.shade700,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                  ),
                                                ),
                                              if (0 != null)
                                                Positioned(
                                                  top: 16,
                                                  right: 16,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() async {
                                                        await Wishlist
                                                            .getAddWishlist(
                                                                product_id: snapshot
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                                productVarientId:
                                                                    '6');
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons
                                                            .favorite_border_outlined,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                  snapshot
                                                      .data!.data![index].name!
                                                      .toString(),
                                                  style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15,
                                                      height: 1.5,
                                                    ),
                                                  )),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text('Gross Wt ',
                                                            style: TextStyle(
                                                                fontSize: 12)),
                                                        Text('Stone %',
                                                            style: TextStyle(
                                                                fontSize: 12)),
                                                        Text('Net Wt',
                                                            style: TextStyle(
                                                                fontSize: 12)),
                                                      ],
                                                    ),
                                                    const Column(
                                                      children: [
                                                        Text('  :  '),
                                                        Text('  :  '),
                                                        Text('  :  '),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${products[index].gw!.toString()} ',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),
                                                        Text(
                                                            snapshot
                                                                .data!
                                                                .data![index]
                                                                .stone!
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12)),
                                                        Text(
                                                            '${products[index].nw!.toString()} ',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12)),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          WhatsappUrl.launchWhatsapp(
                                                            number: "7021251102",
                                                            message:
                                                                '${GlobalK.productName}\n${GlobalK.productId}\n${GlobalK.totalProduct}',
                                                          );
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .green),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: const Icon(
                                                            FontAwesomeIcons
                                                                .whatsapp,
                                                            color: Colors.green,
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ))
        ],
      ),
      floatingActionButton: isSelectMode && selectedProductIds.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                // TODO: Implement PDF Generation
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

  Shimmer getShimmerLodaing() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
