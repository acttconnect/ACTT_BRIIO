import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:briio_application/screens/pages/categories/main_category_screen.dart';
import 'package:briio_application/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  int _selectedPlanIndex = 1; // Default to Premium
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _plans = [
    {
      'title': 'Basic',
      'price': '499',
      'duration': '/month',
      'desc': 'For casual buyers',
      'features': [
        'Standard collections access',
        'Basic email support',
        'Standard delivery',
      ]
    },
    {
      'title': 'Premium',
      'price': '999',
      'duration': '/month',
      'desc': 'Most popular choice',
      'isPopular': true,
      'features': [
        'Access to ALL collections',
        'Priority 24/7 support',
        'Free expedited delivery',
        'Early access to designs',
      ]
    },
    {
      'title': 'Pro Yearly',
      'price': '4,999',
      'duration': '/year',
      'desc': 'Best value for money',
      'features': [
        'Everything in Premium',
        'Massive yearly savings',
        'Personal styling consultant',
        'Exclusive VIP events',
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'BRIIO PLUS',
          style: GoogleFonts.poppins(
            color: AppColors.logo2,
            fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: List.generate(
                    _plans.length,
                    (index) => _buildPlanCard(index),
                  ),
                ),
              ),
              const SizedBox(height: 120), // Spacing for bottom button
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildBottomButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.yellowcolorColor.withOpacity(0.15),
            ),
            child: Icon(
              Icons.diamond_outlined,
              size: 40,
              color: Colors.amber.shade700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Experience True Luxury',
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.logo2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Join our exclusive members club and unlock a world of premium jewellery and unparalleled service.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(int index) {
    bool isSelected = _selectedPlanIndex == index;
    var plan = _plans[index];
    bool isPopular = plan.containsKey('isPopular') && plan['isPopular'] == true;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlanIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.amber.shade700 : Colors.transparent,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ]
              : [],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan['title'],
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? AppColors.logo2
                                  : Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            plan['desc'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              isSelected ? Colors.amber.shade700 : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? Colors.amber.shade700
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check,
                                size: 16, color: Colors.white)
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${plan['price']}',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.logo2,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          plan['duration'],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isSelected) ...[
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFEEEEEE), thickness: 1),
                    const SizedBox(height: 20),
                    ...List.generate(plan['features'].length, (fIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.amber.shade700,
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                plan['features'][fIndex],
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ]
                ],
              ),
            ),
            if (isPopular)
              Positioned(
                top: -12,
                right: 32,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF252525), Color(0xFF101010)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star,
                          color: Color(0xFFFFD379), size: 12),
                      const SizedBox(width: 4),
                      Text(
                        'Most Popular',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFFFD379),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    var selectedPlan = _plans[_selectedPlanIndex];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -5),
            blurRadius: 20,
          )
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              Get.to(() => const MainCategoryScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.logo2,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continue with ${selectedPlan['title']}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
