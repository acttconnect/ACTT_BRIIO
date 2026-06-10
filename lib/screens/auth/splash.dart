import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/globel_veriable.dart';
import 'sign_in.dart';
import '../pages/categories/main_category_screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  Future<void> checkLoginStatus() async {
    // Wait for the animation to complete + a small delay
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      final userDataString = prefs.getString('userData');

      if (isLoggedIn && userDataString != null) {
        final userData = json.decode(userDataString);

        // Set user data to GlobalK
        GlobalK.userId = userData['id'];
        GlobalK.userFName = userData['name'];
        GlobalK.userEmail = userData['email'];
        GlobalK.phone = userData['phone'];
        GlobalK.companyName = userData['company_name'];
        GlobalK.gst = userData['gst_number'];
        GlobalK.hallMarks = userData['holemarks_license'];
        GlobalK.address = userData['address'] ?? 'Not Updated';
        GlobalK.city = userData['city'] ?? 'Not Updated';
        GlobalK.state = userData['state'] ?? 'Not Updated';
        GlobalK.pincode = userData['pincode'] ?? 'Not Updated';

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainCategoryScreen()),
          );
        }
      } else {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignIn()),
          );
        }
      }
    } catch (e) {
      print('Error loading saved data: $e');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Smooth fade in
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6,
            curve: Curves.easeIn), // Fade in completely by 60% of animation
      ),
    );

    // Smooth and bouncy scale up
    _scaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack, // Premium bounce effect
      ),
    );

    _controller.forward();
    checkLoginStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Image.asset(
              'assets/brlgo.jpeg',
              width: MediaQuery.of(context).size.width * 0.65,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
