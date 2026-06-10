import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryMaroon = Color(0xFF4A0E17);
  static const Color backgroundCream = Color(0xFFFDFBF7);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color gold = Color(0xFFD4AF37);
  static const Color darkGrey = Color(0xFF333333);
  
  static const Color cardCream = Color(0xFFFAF6EB); 
  static const Color footerGold = Color(0xFFF3E5C2);

  static const String serifFont = 'PlayfairDisplay'; 
  static const String sansSerifFont = 'Montserrat';

  static TextStyle headingStyle = const TextStyle(
    fontFamily: serifFont,
    fontFamilyFallback: ['Times New Roman'],
    color: primaryMaroon,
    fontWeight: FontWeight.w800,
    fontSize: 28,
  );

  static TextStyle bodyStyle = const TextStyle(
    fontFamily: sansSerifFont,
    fontFamilyFallback: ['Roboto'],
    color: darkGrey,
    fontSize: 13,
    height: 1.5,
  );
}
