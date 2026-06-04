import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../classes/whatsaap.dart';
import '../screens/home/home.dart';
import '../screens/pages/image_picker.dart';
import '../screens/pages/person_profile.dart';
import '../screens/pages/wishlist_page.dart';
import '../screens/pages/cart_page.dart';
import '../utils/colors.dart';
class HomePage5 extends StatefulWidget {
  const HomePage5({super.key});

  @override
  _HomePage5State createState() => _HomePage5State();
}

class _HomePage5State extends State<HomePage5> {
  int pageIndex = 0;
  
  // Add this method to handle back button press
  Future<bool> _onWillPop() async {
    if (pageIndex != 0) {
      setState(() {
        pageIndex = 0;
      });
      return false;
    }
    return true;
  }

  final pages = [
    const HomePage(),
    const CartPage(),
    const UploadImageD(),
    const WishlistPage(),
    const PersonProfile(),
  ];
  List<String> name = [
    'Home',
    'Notification',
    'Custom Order',
    'Watchlist',
    'Profile'
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          onPressed: () {
            WhatsappUrl.launchWhatsapp(
              number: "7970099707",
              message: 'Type your query...',
            );
          },
          child: Image.asset('assets/wapp.png'),
        ),
        backgroundColor: Colors.white,
        body: pages[pageIndex],
        bottomNavigationBar: BottomBar(
          currentIndex: pageIndex,
          onTap: (index) {
            setState(() {
              pageIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.house_fill),
          activeIcon: Icon(CupertinoIcons.house_fill),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.cart_fill),
          activeIcon: Icon(CupertinoIcons.cart_fill),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera),
          activeIcon: Icon(Icons.camera),
          label: 'Custom Order',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.heart_fill),
          activeIcon: Icon(CupertinoIcons.heart_fill),
          label: 'Watchlist',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.person_alt_circle),
          activeIcon: Icon(CupertinoIcons.person_alt_circle),
          label: 'Profile',
        ),
      ],
      backgroundColor: Colors.white,
      unselectedFontSize: 9,
      selectedFontSize: 9,
      showSelectedLabels: true,
      selectedItemColor: Colors.grey.shade700,
      unselectedItemColor: Colors.grey.shade700,
      elevation: 0,
      unselectedLabelStyle: const TextStyle(
         fontSize: 9, color: AppColors.logo2),
      selectedLabelStyle: const TextStyle(
          fontSize: 9, color: AppColors.logo2),
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
