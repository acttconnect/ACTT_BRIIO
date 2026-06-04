// ignore_for_file: prefer_typing_uninitialized_variables, deprecated_member_use
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../classes/product_detail.dart';
import '../../classes/whatsaap.dart';
import '../../controller/auth_controller.dart';
import '../../model/new_detail_page_model.dart';
import '../../utils/colors.dart';
import '../../utils/globel_veriable.dart';
import '../../widgets/add_cart.dart';
import '../../widgets/big_text.dart';
import '../pages/cart_page.dart';
import '../pages/savedaddress.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({
    super.key,
    required int productId,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

TextEditingController msgController = TextEditingController();

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  var data;
  var counter = 1;
  int _currentIndex = 0;
  bool isLoader = false;
  bool isLoading = false;

  var c;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        isLoader = true;
      });
    });
    _loadProduct();
  }

  void _loadProduct() async {
    final response = await ProductById.getProductById();
    print(response);
  }

  bool obscureText = true;
  List<String> carat = ['18kt', '20kt', '22kt'];
  List<String> weight = ['35.00'];
  List<String> bangleSizes = [
    '2/2',
    '2/3',
    '2/4',
    '2/5',
    '2/6',
    '2/7',
    '2/8',
    '2/9',
    '2/10',
    '2/11',
    '2/12',
    '2/13',
    '2/14',
    '2/15',
    '2/16'
  ];
  String selectedCarat = '22kt';
  String selectedBangleSize = '2/2';
  String selectedinstruction = 'instruction';

  GestureDetector buildBottomSheet({required String size, Color? color}) {
    return GestureDetector(
      onTap: () =>
          c.addToCart(color: color.toString(), msg: msgController.text),
      child: Container(
        height: 50,
        width: double.infinity,
        color: Colors.black,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, color: Colors.black),
            SizedBox(width: 8),
            Text('ADD TO CART', style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        clipBehavior: Clip.none,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: Colors.grey.shade700,
            )),
        centerTitle: true,
        title: Text(
          (GlobalK.productName ?? 'PRODUCT').toUpperCase(),
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: Colors.black,
        actions: [

          IconButton(
            onPressed: () {
              _showShareBottomSheet(context, null);
            },
            icon: Icon(
              Icons.ios_share,
              color: Colors.grey.shade700,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartPage()));
            },
            icon: Icon(
              CupertinoIcons.cart_fill,
              color: Colors.grey.shade700,
            ),
          ),
        ],

      ),
      body: Container(
        margin: const EdgeInsets.all(3),
        child: FutureBuilder<NewDetailPageModel>(
            future: ProductById.getProductById(),
            builder: (context, snapshot) {
              print(snapshot.data);
              print(snapshot.connectionState);
              if (snapshot.hasData && snapshot.data?.product != null && snapshot.data!.product!.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.product!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CarouselSlider.builder(
                                options: CarouselOptions(
                                  height: 320,
                                  aspectRatio: 16 / 9,
                                  viewportFraction: 1,
                                  initialPage: 0,
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _currentIndex = index;
                                    });
                                  },
                                ),
                                itemCount: snapshot
                                    .data!.product![index].images.length,
                                itemBuilder: (BuildContext context,
                                    int itemIndex, int pageViewIndex) {
                                  String imageUrl = snapshot
                                      .data!.product![index].images[itemIndex]!;
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            backgroundColor: Colors.transparent,
                                            child: Container(
                                              width: MediaQuery.of(context).size.width * 0.8,
                                              height: MediaQuery.of(context).size.height * 0.6,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Stack(
                                                children: [
                                                  PhotoView(
                                                    imageProvider: NetworkImage(imageUrl),
                                                    minScale: PhotoViewComputedScale.contained,
                                                    maxScale: PhotoViewComputedScale.covered * 2,
                                                    backgroundDecoration: const BoxDecoration(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 8,
                                                    top: 8,
                                                    child: IconButton(
                                                      icon: const Icon(Icons.close, color: Colors.black),
                                                      onPressed: () => Navigator.pop(context),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 320,
                                          margin: const EdgeInsets.all(5.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl: imageUrl,
                                              placeholder: (context, url) => const Center(
                                                child: CircularProgressIndicator(),
                                              ),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(width: 80), // Balance the row
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(
                                        snapshot.data!.product![index].images.length,
                                        (dotIndex) => Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                            color: _currentIndex == dotIndex
                                                ? Colors.black
                                                : Colors.grey.shade400,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // TODO: Wishlist logic
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.favorite_border,
                                              color: Colors.black54,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        GestureDetector(
                                          onTap: () async {
                                            WhatsappUrl.launchWhatsapp(
                                              number: "7970099707",
                                              message:
                                                  '${snapshot.data!.product![index].images[0]}\nproduct name: ${GlobalK.productName}\nproduct id: ${GlobalK.productId}\ntotal product: ${GlobalK.totalProduct}\nproduct description: ${snapshot.data!.product![index].shortDesc}\ncategory: ${snapshot.data!.product![index].cname}\nproduct code: ${snapshot.data!.product![index].productCode}\ngross weight: ${snapshot.data!.product![index].gw}\nnet weight: ${snapshot.data!.product![index].nw}',
                                            );
                                          },
                                          child: Image.asset('assets/whatsapp.png', // Or wapp.png, using standard whatsapp icon if available
                                              height: 40, width: 40),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 5, right: 5, left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'PRODUCT DESCRIPTION',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    obscureText
                                        ? Text(
                                            snapshot
                                                .data!.product![index].shortDesc
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.black38),
                                          )
                                        : Text(
                                            ' ${snapshot.data!.product![index].shortDesc.toString()}',
                                            style:
                                                GoogleFonts.lato(fontSize: 14)),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                color: Colors.white,
                                width: double.infinity,
                                child: const Text(
                                  'PRODUCT DETAILS',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                              _boxes(
                                  'Category',
                                  snapshot.data!.product![index].cname
                                      .toString()),
                              _boxes(
                                  'Code',
                                  snapshot.data!.product![index].productCode
                                      .toString()),
                              _boxes('Gross Wt.',
                                  '${snapshot.data!.product![index].gw ?? '-'} gram'),
                              _boxes("Net Wt.",
                                  '${snapshot.data!.product![index].nw ?? '-'} gram'),
                              _boxes('Less Wt.',
                                  '${snapshot.data!.product![index].stone ?? '-'} gram'),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                color: Colors.white,
                                width: double.infinity,
                                child: const Text('GOLD PURITY',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: DropdownButtonFormField<String>(
                                  dropdownColor: Colors.white,  // Add this line
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0),
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  value: selectedCarat,
                                  items: carat
                                      .map((e) => DropdownMenuItem<String>(
                                          value: e, child: Text(e)))
                                      .toList(),
                                  onChanged: (value) => setState(
                                    () => selectedCarat = value!,
                                  ),
                                  validator: (value) {
                                    if (value == "-----") {
                                      return 'Please select';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) => setState(() {
                                    selectedCarat = newValue!;
                                  }),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                color: Colors.white,
                                width: double.infinity,
                                child: const Row(
                                  children: [
                                    Text('BANGLE SIZE',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: DropdownButtonFormField<String>(
                                  dropdownColor: Colors.white,  // Add this line
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0),
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  value: selectedBangleSize,
                                  items: bangleSizes
                                      .map((e) => DropdownMenuItem<String>(
                                          value: e, child: Text(e)))
                                      .toList(),
                                  onChanged: (value) => setState(
                                    () => selectedBangleSize = value!,
                                  ),
                                  validator: (value) {
                                    if (value == "-----") {
                                      return 'Please select';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) => setState(() {
                                    selectedBangleSize = newValue!;
                                  }),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                '   ADD INSTRUCTIONS (OPTIONAL)',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: TextField(
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  controller: msgController,
                                  decoration: InputDecoration(
                                    hintText: 'Type here',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: 50,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: AddToTheCart(
                              productId: GlobalK.productId,
                              height: 100,
                              width: 180,
                              bangleSize: selectedBangleSize,
                              goldPurity: selectedCarat,
                              weight: snapshot.data!.product![0].gw?.toString() ?? '-',
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (GlobalK.userId.isNull) {
                                  AuthLogin.logout();
                                }
                                setState(() {
                                  GlobalK.productId;
                                });
                                Get.to(
                                  () => SavedAddress(
                                    forOrder: true,
                                    productId: int.parse(GlobalK.productId!),
                                    goldPurity: selectedCarat,
                                    bangleSize: selectedBangleSize,
                                  
                                    instruction: msgController.text,
                                    weight: snapshot.data!.product![0].gw?.toString() ?? '-',
                                  ),
                                )?.then((_) {
                                  msgController.clear();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.logo2,
                                    borderRadius: BorderRadius.circular(7)),
                                child: const Center(
                                  child: Text(
                                    'ORDER',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Failed to load details: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  Widget _boxes(String details, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BigText(
                  text: details,
                ),
                BigText(
                  text: value,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            width: double.maxFinite,
          ),
        ],
      ),
    );
  }

  void _showShareBottomSheet(BuildContext context, dynamic product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/logo_bg.png',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${product?.productCode ?? 'product'}.pdf',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // TODO: Implement actual PDF share
                        },
                        icon: const Icon(Icons.ios_share),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  )
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Implement Create New Customer
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.black87),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Create New Customer',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Shimmer getShimcsmerLodaing() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
