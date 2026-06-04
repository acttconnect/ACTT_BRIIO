// ignore_for_file: unnecessary_null_comparison, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'package:briio_application/screens/pages/notifiction_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/shimmer_loading.dart';
import '../pages/categories/main_category_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../classes/categories.dart';
import '../../model/catogries_model.dart';
import '../../model/home_model.dart';
import '../../utils/colors.dart';
import '../../utils/const.dart';
import '../../utils/globel_veriable.dart';
import '../pages/categories/subCategory.dart';
import '../pages/search_page.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _imageUrls = [];
  bool _isLoading = true;

  Future<Map<String, String>> _fetchSocialLinks() async {
    // Soft code API simulation (Replace with actual endpoint later)
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'facebook': 'https://facebook.com/briio.in',
      'twitter': 'https://twitter.com/briio_in',
      'instagram': 'https://instagram.com/briio.in',
      'youtube': 'https://youtube.com/@briio',
      'linkedin': 'https://linkedin.com/company/briio',
    };
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.grey.shade600,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  Future<Home2Model> getData() async {
    String? uri = '${apiUrl}HomeData';
    if (GlobalK.mainCategoryId != null) {
      uri += '?main_category_id=${GlobalK.mainCategoryId}';
    }
    try {
      var response = await http.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return Home2Model.fromJson(data);
      } else {
        throw Exception('Failed to load Home Data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching home data: $e');
      throw Exception('Failed to load home data: $e');
    }
  }

  bool isLoader = false;
  int _currentIndex = 0;

  late Future<Home2Model> _homeDataFuture;
  late Future<CatogriesModel> _categoriesFuture;

  final ScrollController _tickerScrollController = ScrollController();
  Timer? _tickerTimer;

  @override
  void initState() {
    super.initState();
    _fetchImages();
    _homeDataFuture = getData();
    _categoriesFuture = CategoriesView.getPro();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _tickerTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_tickerScrollController.hasClients) {
        double currentOffset = _tickerScrollController.offset;
        double maxExtent = _tickerScrollController.position.maxScrollExtent;

        if (currentOffset >= maxExtent) {
          _tickerScrollController.jumpTo(0.0);
        } else {
          _tickerScrollController.jumpTo(currentOffset + 1.0);
        }
      }
    });
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _tickerScrollController.dispose();
    super.dispose();
  }

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _fetchImages() async {
    try {
      String uri = '${apiUrl}home-slide';
      if (GlobalK.mainCategoryId != null) {
        uri += '?main_category_id=${GlobalK.mainCategoryId}';
      }
      var request = http.Request('GET', Uri.parse(uri));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);

        if (data['error'] == false && data['data'] is List) {
          setState(() {
            _imageUrls = (data['data'] as List)
                .map((item) => item['image'].toString().startsWith('http')
                    ? item['image'].toString()
                    : "${imgPath}homesliders/${item['image']}")
                .toList();
            _isLoading = false;
          });
        } else {
          // Handle case where data is not a list or there's an error
        }
      } else {}
    } catch (e) {
      // Handle error
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (GlobalK.mainCategoryId != null) {
            GlobalK.mainCategoryId = null;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          drawer: Drawer(
            backgroundColor: Colors.grey.shade100,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: _buildUi(),
          ),
          appBar: AppBar(
            surfaceTintColor: Colors.white,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            elevation: 0,
            leadingWidth: 100,
            leading: Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.grid_view_outlined, size: 24),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainCategoryScreen()),
                    );
                  },
                ),
              ],
            ),
            title: Image.asset(
              'assets/blg.png',
              height: 28,
              fit: BoxFit.contain,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage()));
                },
                icon: const Icon(Icons.search),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationPage()));
                },
              ),
            ],
          ),
          body: Column(
            children: [
              _buildLiveTicker(),
              Expanded(
                child: FutureBuilder<Home2Model>(
                  future: _homeDataFuture,
                  builder: (context, snapshot) => snapshot.hasData
                      ? SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              if (snapshot.data!.banner != null &&
                                  snapshot.data!.banner!.isNotEmpty) ...[
                                SizedBox(
                                  height: 190,
                                  width: double.infinity,
                                  child: ListView(
                                    padding: EdgeInsets.zero,
                                    children: [
                                      CarouselSlider.builder(
                                        itemCount:
                                            snapshot.data!.banner!.length,
                                        itemBuilder:
                                            (context, index, realIndex) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot.data!
                                                      .banner![index].image
                                                      .toString()
                                                      .startsWith('http')
                                                  ? snapshot.data!
                                                      .banner![index].image
                                                      .toString()
                                                  : "${imgPath}homesliders/${snapshot.data!.banner![index].image.toString()}",
                                              fit: BoxFit.cover,
                                              memCacheWidth: 1200,
                                              memCacheHeight: 600,
                                              maxWidthDiskCache: 1200,
                                              maxHeightDiskCache: 600,
                                              placeholder: (context, url) =>
                                                  const ShimmerLoading(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        options: CarouselOptions(
                                          height: 190.0,
                                          autoPlay: true,
                                          viewportFraction: 1,
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          autoPlayAnimationDuration:
                                              const Duration(milliseconds: 800),
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _currentIndex = index;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                      snapshot.data!.banner!.length,
                                      (index) => Container(
                                            margin: const EdgeInsets.only(
                                                top: 10, right: 8),
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _currentIndex == index
                                                    ? AppColors.logo2
                                                    : Colors.grey),
                                          )),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                              Container(
                                margin: const EdgeInsets.all(5),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    FutureBuilder<CatogriesModel>(
                                        future: _categoriesFuture,
                                        builder: (context, catSnapshot) {
                                          if (catSnapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error loading categories: ${catSnapshot.error}'));
                                          }
                                          if (!catSnapshot.hasData ||
                                              catSnapshot.data?.data == null) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          return GridView.count(
                                            crossAxisSpacing: 14,
                                            mainAxisSpacing: 14,
                                            shrinkWrap: true,
                                            crossAxisCount: 2,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            children: [
                                              for (final category
                                                  in catSnapshot.data!.data!)
                                                Builder(builder: (context) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        GlobalK.categoryId =
                                                            category.id
                                                                .toString();
                                                      });
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SubCategory(
                                                            categoryId:
                                                                category.id ??
                                                                    0,
                                                            categoryName:
                                                                category.name ??
                                                                    'Unknown',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Stack(
                                                      fit: StackFit.expand,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: category
                                                                    .image!
                                                                    .toString()
                                                                    .startsWith(
                                                                        'http')
                                                                ? category
                                                                    .image!
                                                                    .toString()
                                                                : '${imgPath}category/${category.image!.toString()}',
                                                            fit: BoxFit.cover,
                                                            placeholder: (context,
                                                                    url) =>
                                                                const ShimmerLoading(),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                Container(
                                                                    color: Colors
                                                                            .grey[
                                                                        200]),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          bottom: 10,
                                                          left: 0,
                                                          right: 0,
                                                          child: Center(
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          16,
                                                                      vertical:
                                                                          4),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.4),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              child: Text(
                                                                category.name ??
                                                                    '',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                            ],
                                          );
                                        })
                                  ],
                                ),
                              ),
                              if (snapshot.data!.bestseller != null &&
                                  snapshot.data!.bestseller!.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    'Products',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 0.8,
                                  ),
                                  itemCount: snapshot.data!.bestseller!.length,
                                  itemBuilder: (context, index) {
                                    final product =
                                        snapshot.data!.bestseller![index];
                                    return GestureDetector(
                                      onTap: () {
                                        GlobalK.productId =
                                            product.id.toString();
                                        GlobalK.productName =
                                            product.name.toString();
                                        Get.to(() => ProductDetailsPage(
                                              productId: product.id ?? 0,
                                            ));
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  child: CachedNetworkImage(
                                                    imageUrl: product.image
                                                            .toString()
                                                            .startsWith('http')
                                                        ? product.image
                                                            .toString()
                                                        : "${imgPath}products/${product.image}",
                                                    fit: BoxFit.cover,
                                                    memCacheWidth: 400,
                                                    placeholder: (context,
                                                            url) =>
                                                        const ShimmerLoading(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons
                                                            .image_not_supported),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    product.name.toString(),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 3),
                                                  Text(
                                                    "Gross wt: ${product.gw ?? ''}",
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 5),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                              ],
                              // SizedBox(
                              //   height: 220,
                              //   width: double.infinity,
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(10),
                              //       image: const DecorationImage(
                              //         image: AssetImage('assets/briio.gif'),
                              //         fit: BoxFit.cover,
                              //       ),
                              //     ),
                              //     margin: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                              //     // height: 30,
                              //     width: 300,
                              //   ),
                              // ),
                              const SizedBox(
                                height: 10,
                              ),
                              _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : _imageUrls.isNotEmpty
                                      ? Column(children: [
                                          SizedBox(
                                            height: 190,
                                            width: double.infinity,
                                            child: ListView(
                                              padding: EdgeInsets.zero,
                                              children: [
                                                CarouselSlider.builder(
                                                  itemCount: _imageUrls.length,
                                                  itemBuilder: (context, index,
                                                          realIndex) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            _imageUrls[index],
                                                        fit: BoxFit.cover,
                                                        placeholder: (context,
                                                                url) =>
                                                            const ShimmerLoading(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                  options: CarouselOptions(
                                                    height: 190,
                                                    autoPlay: true,
                                                    viewportFraction: 1,
                                                    autoPlayCurve:
                                                        Curves.fastOutSlowIn,
                                                    autoPlayAnimationDuration:
                                                        const Duration(
                                                            milliseconds: 800),
                                                    onPageChanged:
                                                        (index, reason) {
                                                      setState(() {
                                                        _currentIndex = index;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: List.generate(
                                                _imageUrls.length,
                                                (index) => Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              right: 8),
                                                      height: 10,
                                                      width: 10,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              _currentIndex ==
                                                                      index
                                                                  ? AppColors
                                                                      .logo2
                                                                  : Colors
                                                                      .grey),
                                                    )),
                                          ),
                                        ])
                                      : Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.grey.shade100,
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'No images available',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'WHY BRIIO',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              const WhyBrllo(
                                text: '100% Certified Jewellery',
                                image:
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-Nc0UXZd5WM0WrEi4YX7kH5LwUhYg9l1ey3Ra67o&s',
                              ),
                              const WhyBrllo(
                                text: 'Value for Money',
                                image:
                                    'https://www.shutterstock.com/image-vector/pay-vector-thin-line-icon-260nw-1799803231.jpg',
                              ),
                              const WhyBrllo(
                                text: "Easily Exchange within 24 hours",
                                image:
                                    'https://st2.depositphotos.com/13981182/50896/v/600/depositphotos_508968392-stock-illustration-rupees-chargeback-vector-icon-simple.jpg',
                              ),
                              const WhyBrllo(
                                text: 'Free Shipping & Insurance',
                                image:
                                    'https://www.shutterstock.com/image-vector/shipping-free-delivery-van-icon-260nw-1253868556.jpg',
                              ),
                              const WhyBrllo(
                                  text:
                                      'Explore 1L+ designs on your finger tips',
                                  image:
                                      'https://static.thenounproject.com/png/1306779-200.png'),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Follow us on',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                child: FutureBuilder<Map<String, String>>(
                                  future: _fetchSocialLinks(), // Soft coded API fetch
                                  builder: (context, snapshot) {
                                    final links = snapshot.data ?? {
                                      'facebook': 'https://facebook.com/briio.in',
                                      'twitter': 'https://twitter.com/briio_in',
                                      'instagram': 'https://instagram.com/briio.in',
                                      'youtube': 'https://youtube.com/@briio',
                                      'linkedin': 'https://linkedin.com/company/briio',
                                    };
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildSocialIcon(FontAwesomeIcons.facebookF, links['facebook']!),
                                        _buildSocialIcon(FontAwesomeIcons.twitter, links['twitter']!),
                                        _buildSocialIcon(FontAwesomeIcons.instagram, links['instagram']!),
                                        _buildSocialIcon(FontAwesomeIcons.youtube, links['youtube']!),
                                        _buildSocialIcon(FontAwesomeIcons.linkedinIn, links['linkedin']!),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                height: 60,
                              )
                            ],
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ),
            ],
          ),
          // bottomNavigationBar: const BottomBars(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Add WhatsApp functionality here
            },
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              FontAwesomeIcons.whatsapp,
              color: Colors.white,
              size: 32,
            ),
          ),
        ));
  }

  Widget _buildLiveTicker() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: ListView.builder(
        controller: _tickerScrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10000,
        itemBuilder: (context, index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              const Text(
                '72,342',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
              const Icon(Icons.arrow_upward, color: Colors.green, size: 14),
              const SizedBox(width: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              const Text(
                'SILVER',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87),
              ),
              const SizedBox(width: 5),
              const Text(
                '1,21,342',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.red),
              ),
              const Icon(Icons.arrow_downward, color: Colors.red, size: 14),
              const SizedBox(width: 15),
              const Text(
                'GOLD 999',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87),
              ),
              const SizedBox(width: 5),
              const Text(
                '7,12,342',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.green),
              ),
              const Icon(Icons.arrow_upward, color: Colors.green, size: 14),
              const SizedBox(width: 10),
            ],
          );
        },
      ),
    );
  }

  evluction2() {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      color: Colors.white,
      child: Column(
        children: [
          GestureDetector(
            onTap: _toggle,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.greenAccent,
                backgroundImage: AssetImage(
                  'assets/logo_bg.png',
                ),
              ),
              title: Text('Evolution of Group',
                  style: GoogleFonts.lato(
                      height: 1, fontSize: 18, fontWeight: FontWeight.w800)),
              trailing: const Icon(
                Icons.keyboard_arrow_up_outlined,
                size: 35,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: const Text(
                'Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type .'),
          )
        ],
      ),
    );
  }

  Widget _buildUi() {
    return SafeArea(
      child: Container(
        color: Colors.grey
            .shade100, // Make sure whole drawer background is grey to show gaps
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              color: Colors.white,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: Text(
                  '₹',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.amber.shade700,
                      fontWeight: FontWeight.bold),
                ),
                title: Text(
                  'LIVE RATES',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios,
                    size: 18, color: Colors.black87),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
              color: Colors.white,
              child: Text(
                'My Account',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            if (GlobalK.userFName == null || GlobalK.userFName!.isEmpty) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                color: Colors.white,
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  title: Text(
                    'Login',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to Login
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                color: Colors.white,
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  title: Text(
                    'Register',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to Register
                  },
                ),
              ),
            ] else ...[
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                color: Colors.white,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                        GlobalK.userFName![0].toUpperCase(),
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            GlobalK.userFName ?? '',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (GlobalK.userEmail != null &&
                              GlobalK.userEmail!.isNotEmpty)
                            Text(
                              GlobalK.userEmail!,
                              style: GoogleFonts.poppins(
                                  fontSize: 13, color: Colors.grey[500]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              color: Colors.grey.shade50,
              child: Text(
                'OUR COLLECTION',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<CatogriesModel>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data?.data == null ||
                      snapshot.data!.data!.isEmpty) {
                    return Center(
                        child: Text('No Categories Found',
                            style: GoogleFonts.poppins(color: Colors.grey)));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.data!.length + 1,
                    itemBuilder: (context, index) {
                      if (index == snapshot.data!.data!.length) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          color:
                              Colors.transparent, // Background is already grey
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.workspace_premium,
                                  color: Colors.grey.shade400, size: 28),
                              const SizedBox(width: 10),
                              Text(
                                'Bis Hallmarked Jewellery',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // close drawer
                          GlobalK.categoryId =
                              snapshot.data!.data![index].id!.toString();
                          Get.to(() => SubCategory(
                                categoryId: snapshot.data!.data![index].id ?? 0,
                                categoryName:
                                    snapshot.data!.data![index].name ??
                                        'Unknown',
                              ));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 4), // Margin creates the exact grey gap!
                          color: Colors.white,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            title: Text(
                                snapshot.data!.data![index].name!.toString(),
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700)),
                            trailing: Icon(Icons.arrow_forward_ios,
                                size: 14, color: Colors.grey[400]),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
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
        ));
  }
}

class WhyBrllo extends StatefulWidget {
  const WhyBrllo({super.key, this.text, this.image});
  final String? text;
  final String? image;

  @override
  State<WhyBrllo> createState() => _WhyBrlloState();
}

class _WhyBrlloState extends State<WhyBrllo> {
  bool _obscureText = false;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: GestureDetector(
        onTap: _toggle,
        child: ListTile(
          tileColor: Colors.white,
          title: Text(
            "${widget.text}",
            style: GoogleFonts.lato(
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
          ),
          // trailing: _obscureText == true
          //     ? const Icon(Icons.keyboard_arrow_down)
          //     : const Icon(Icons.keyboard_arrow_up),
          leading: CachedNetworkImage(
            imageUrl: '${widget.image}',
            width: 40,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

//success on sharing project on git hub
//success on sharing project on git hub
//success on sharing project on git hub
//success on sharing project on git hub
