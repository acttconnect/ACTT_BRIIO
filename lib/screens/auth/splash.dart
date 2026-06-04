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

class _SplashState extends State<Splash> {
  bool isSelected = false;

  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    
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
            MaterialPageRoute(builder: (context) => const SignIn()),
          );
        }
      }
    } catch (e) {
      print('Error loading saved data: $e');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    Future.delayed(
      const Duration(milliseconds: 200),
      () => setState(() => isSelected = true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => setState(() => isSelected = !isSelected),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(seconds: 2),
            height: isSelected ? 110 : 50,
            width: isSelected ? 280 : 50,
            curve: Curves.easeOutCirc,
            child: Image.asset('assets/blg.png'),
          ),
        ),
      ),
    );
  }
}
