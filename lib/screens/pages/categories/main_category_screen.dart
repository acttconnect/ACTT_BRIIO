import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../model/main_category_model.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../home/api_services.dart';
import '../../../utils/globel_veriable.dart';
import '../../../utils/const.dart';
import '../../../widgets/buttom_bar.dart';

class MainCategoryScreen extends StatefulWidget {
  const MainCategoryScreen({super.key});

  @override
  State<MainCategoryScreen> createState() => _MainCategoryScreenState();
}

class _MainCategoryScreenState extends State<MainCategoryScreen> {
  bool _isLoading = true;
  List<MainCategory> _mainCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchMainCategories();
  }

  Future<void> _fetchMainCategories() async {
    final response = await ApiServices().getMainCategories();
    if (response != null && response.data != null) {
      setState(() {
        _mainCategories = response.data!;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Image.asset('assets/blg.png', height: 28, fit: BoxFit.contain),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _mainCategories.isEmpty
              ? const Center(child: Text("No categories available."))
              : Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _mainCategories.length,
                          
                          itemBuilder: (context, index) {
                            final category = _mainCategories[index];
                            return GestureDetector(
                              onTap: () {
                                GlobalK.mainCategoryId = category.id?.toString();
                                Get.to(() => const HomePage5());
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                height: MediaQuery.of(context).size.height / 3.3, // take approx 1/3 of screen space
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(25),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Stack(
                                    children: [
                                      // Background Image (Gradient)
                                      Positioned.fill(
                                        child: Builder(
                                          builder: (context) {
                                            String bgUrl = category.bgimage ?? '';
                                            if (bgUrl.isNotEmpty && !bgUrl.startsWith('http')) bgUrl = '${imgPath}category/$bgUrl';
                                            if (bgUrl.isEmpty) return const SizedBox();
                                            return CachedNetworkImage(
                                              imageUrl: bgUrl.replaceAll(' ', '%20'),
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
                                          }
                                        ),
                                      ),
                                      // Foreground Image (Model)
                                      if (category.image != null && category.image!.isNotEmpty)
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          top: 0,
                                          child: Builder(
                                            builder: (context) {
                                              String imgUrl = category.image ?? '';
                                              if (imgUrl.isNotEmpty && !imgUrl.startsWith('http')) imgUrl = '${imgPath}category/$imgUrl';
                                              if (imgUrl.isEmpty) return const SizedBox();
                                              return CachedNetworkImage(
                                                imageUrl: imgUrl.replaceAll(' ', '%20'),
                                                fit: BoxFit.contain,
                                                alignment: Alignment.centerRight,
                                              );
                                            }
                                          ),
                                        ),
                                      // Text Overlay
                                      Positioned(
                                        left: 24,
                                        top: 0,
                                        bottom: 0,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              category.name?.toUpperCase().replaceAll(' JEWELLERY', '') ?? '',
                                              style: GoogleFonts.inter(
                                                fontSize: 26,
                                                fontWeight: FontWeight.w900,
                                                color: const Color(0xFF4A433A),
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Jewellery',
                                              style: GoogleFonts.inter(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF4A433A),
                                              ),
                                            ),
                                          ],
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
    );
  }
}
