import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/product_model.dart';
import '../data/dummy_data.dart';

class CatalogPreviewScreen extends StatelessWidget {
  const CatalogPreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: const Text('Catalog Preview')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildPageContainer(const CatalogPage1()),
              const SizedBox(height: 20),
              _buildPageContainer(const CatalogPage2()),
              const SizedBox(height: 20),
              _buildPageContainer(const CatalogPage3()),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContainer(Widget child) {
    return Container(
      width: 794,
      height: 1123,
      decoration: BoxDecoration(
        color: AppTheme.backgroundCream,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }
}

class CatalogPage1 extends StatelessWidget {
  const CatalogPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundCream,
      child: Stack(
        children: [
          Positioned(
            top: 40,
            left: 40,
            child: Icon(Icons.auto_awesome, color: AppTheme.gold.withOpacity(0.5), size: 30),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 80),
              Column(
                children: [
                  Text(
                    'JAI SHREE JEWELLERS',
                    style: AppTheme.headingStyle.copyWith(letterSpacing: 2.0),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'jewellery collection',
                    style: TextStyle(
                      fontFamily: AppTheme.serifFont,
                      fontFamilyFallback: const ['Times New Roman'],
                      fontStyle: FontStyle.italic,
                      color: AppTheme.gold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 150,
                    height: 1,
                    color: AppTheme.gold.withOpacity(0.5),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Center(
                      child: Icon(Icons.image, size: 100, color: Colors.grey[300]),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    'Timeless Elegance in Every Design',
                    style: TextStyle(
                      fontFamily: AppTheme.serifFont,
                      fontFamilyFallback: const ['Times New Roman'],
                      color: AppTheme.gold,
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 80),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryMaroon,
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.water_drop, color: AppTheme.pureWhite, size: 40),
                        const SizedBox(height: 10),
                        Text(
                          'JAISHREE',
                          style: TextStyle(
                            fontFamily: AppTheme.serifFont,
                            fontFamilyFallback: const ['Times New Roman'],
                            color: AppTheme.pureWhite,
                            fontSize: 20,
                            letterSpacing: 4.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'JEWELLERS PVT. LTD',
                          style: TextStyle(
                            fontFamily: AppTheme.sansSerifFont,
                            fontFamilyFallback: const ['Roboto'],
                            color: AppTheme.pureWhite.withOpacity(0.8),
                            fontSize: 8,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CatalogPage2 extends StatelessWidget {
  const CatalogPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundCream,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dummyProducts.length,
              itemBuilder: (context, index) {
                return _buildProductCard(dummyProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(CatalogProduct product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardCream,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: AppTheme.pureWhite,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => 
                  Icon(Icons.image, size: 50, color: Colors.grey[300]),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.code,
                  style: TextStyle(
                    fontFamily: AppTheme.sansSerifFont,
                    fontFamilyFallback: const ['Roboto'],
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppTheme.darkGrey,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  product.description,
                  style: TextStyle(
                    fontFamily: AppTheme.sansSerifFont,
                    fontFamilyFallback: const ['Roboto'],
                    color: const Color(0xFF555555),
                    fontSize: 13,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product.weight,
                    style: TextStyle(
                      fontFamily: AppTheme.sansSerifFont,
                      fontFamilyFallback: const ['Roboto'],
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryMaroon,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CatalogPage3 extends StatelessWidget {
  const CatalogPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.pureWhite,
      child: Stack(
        children: [
          Positioned(
            top: 40,
            left: 40,
            child: Icon(Icons.auto_awesome, color: AppTheme.gold.withOpacity(0.5), size: 30),
          ),
          Positioned(
            top: 40,
            right: 40,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text('3/3', style: TextStyle(color: Colors.grey)),
            ),
          ),
          Center(
            child: Icon(
              Icons.filter_vintage, 
              size: 300, 
              color: const Color(0xFFF7F7F7),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Text(
                'THANK YOU',
                style: AppTheme.headingStyle.copyWith(
                  color: AppTheme.primaryMaroon.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: Text(
                  'The designs showcased in this catalogue highlight our approach to jewellery design, where traditional craftsmanship is thoughtfully blended with refined detailing and contemporary sensibilities. Every piece is carefully conceptualized to inspire creativity and support custom jewellery creation, offering endless possibilities for personalization. Our collection reflects a deep appreciation for artistry, precision, and timeless elegance. Stay connected with us to explore many more exclusive, innovative, and uniquely crafted designs as we continue to evolve and bring new inspirations to life.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTheme.sansSerifFont,
                    fontFamilyFallback: const ['Roboto'],
                    color: const Color(0xFF666666),
                    fontSize: 14,
                    height: 1.8,
                  ),
                ),
              ),
              const Spacer(flex: 3),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                color: AppTheme.footerGold,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20,
                  runSpacing: 10,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.phone, color: AppTheme.primaryMaroon, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          '+919425886678, 9425668753',
                          style: TextStyle(
                            fontFamily: AppTheme.sansSerifFont,
                            fontFamilyFallback: const ['Roboto'],
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryMaroon,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, color: AppTheme.primaryMaroon, size: 18),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'D.N.R 90 Yeshwant Niwas Road near Rajani Bhawan,\nLad Colony, Indore, (M.P.)',
                            style: TextStyle(
                              fontFamily: AppTheme.sansSerifFont,
                              fontFamilyFallback: const ['Roboto'],
                              color: AppTheme.primaryMaroon,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
