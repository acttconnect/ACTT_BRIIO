// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../classes/search.dart';
import '../../classes/whatsaap.dart';
import '../../classes/wishlist.dart';
import '../../model/new_search_models.dart';
import '../../utils/const.dart';
import '../../utils/globel_veriable.dart';
import '../home/product_detail_page.dart';
import 'categories/filter_page.dart';
import '../../utils/pdf_generator.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchText = TextEditingController();
  bool isSelectMode = false;
  Set<int> selectedProductIds = {};
  List<Data> currentSearchResults = [];
  Filters filters = Filters();
  String sortOrder = 'default';

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
  void initState() {
    super.initState();
    searchText.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new,size: 18,color: Colors.grey.shade700,)),
        clipBehavior: Clip.none,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text('SEARCH',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: searchText,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search for products',
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          searchText.text.isEmpty
              ? Container()
              : Expanded(
                  child: FutureBuilder<NewSearchModel>(
                    future: SearchApi.getUserModule(searchText.text),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.data!.isEmpty) {
                          return const Center(
                            child: Text('No Result found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                )),
                          );
                        } else {
                          var results = snapshot.data!.data!.where((product) {
                            return (product.gw ?? 0) >= filters.weightFrom &&
                                (product.gw ?? 0) <= filters.weightTo;
                          }).toList();
                          if (sortOrder == 'lowToHigh') {
                            results.sort((a, b) => (a.gw ?? 0).compareTo(b.gw ?? 0));
                          } else if (sortOrder == 'highToLow') {
                            results.sort((a, b) => (b.gw ?? 0).compareTo(a.gw ?? 0));
                          }
                          
                          return Column(
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
                              Builder(builder: (context) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  if (mounted) currentSearchResults = results;
                                });
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GridView.builder(
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 10,
                                        childAspectRatio: 1.0,
                                        mainAxisSpacing: 10,
                                        crossAxisCount: 2,
                                      ),
                                      itemCount: results.length,
                                      itemBuilder: (context, index) => buildProductSearchCard(results[index]),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
        ],
      ),
      floatingActionButton: isSelectMode && selectedProductIds.isNotEmpty
          ? FloatingActionButton(
              heroTag: null,
              onPressed: () async {
                final selectedItems = currentSearchResults.where((p) => selectedProductIds.contains(p.id)).toList();
                PdfGenerator.showShareBottomSheet(context, selectedItems, 'Search Results');
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

  Container buildProductSearchCard(Data product) {
    return Container(
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.all(8),
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
          Stack(
            alignment: Alignment.center,
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
                      GlobalK.productId =
                          '${product.id!.toString()} ';
                      GlobalK.productName =
                          '${product.name!.toString()} ';
                    });
                    Get.to(() => const ProductDetailsPage(
                          productId: 0,
                        ));
                  }
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.bottomCenter,
                      image: NetworkImage(
                        '${imgPath}products/${product.image!.toString()}',
                      ),
                      fit: BoxFit.contain,
                    ),
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
              if (0 != null)
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      setState(() async {
                        await Wishlist.getAddWishlist(
                            product_id:
                                product.id.toString(),
                            productVarientId: '6');
                      });
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(product.name!.toString(),
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Gross Wt ', style: TextStyle(fontSize: 12)),
                        Text('Stone %', style: TextStyle(fontSize: 12)),
                        Text('Net Wt', style: TextStyle(fontSize: 12)),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${product.gw!.toString()} ',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(product.stone!.toString(),
                            style: const TextStyle(fontSize: 12)),
                        Text('${product.nw!.toString()} ',
                            style: const TextStyle(fontSize: 12)),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          WhatsappUrl.launchWhatsapp(
                            number: "7021251102",
                            message: 'Type your Query',
                          );
                        },
                        child: const Icon(FontAwesomeIcons.whatsapp))
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
