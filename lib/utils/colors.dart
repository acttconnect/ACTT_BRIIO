import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primaryColor = Color(0xFF212121);    // Deep black
  static const Color secondaryColor = Color(0xFF757575);  // Medium gray
  
  // Text colors
  static const Color textPrimary = Color(0xFF212121);     // Deep black
  static const Color textSecondary = Color(0xFF757575);   // Medium gray
  static const Color textLight = Color(0xFFBDBDBD);       // Light gray
  
  // Background colors
  static const Color background = Color(0xFFFFFFFF);      // White
  static const Color surfaceColor = Color(0xFFF5F5F5);    // Light gray surface
  
  // Border and divider colors
  static const Color borderColor = Color(0xFFE0E0E0);     // Light gray border
  
  // Status colors
  static const Color error = Color(0xFF616161);           // Dark gray for errors
  static const Color success = Color(0xFF424242);         // Darker gray for success

  // Material color for theme
  static MaterialColor materialPrimary = const MaterialColor(
    0xFF212121,
    <int, Color>{
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFEEEEEE),
      300: Color(0xFFE0E0E0),
      400: Color(0xFFBDBDBD),
      500: Color(0xFF212121),
      600: Color(0xFF757575),
      700: Color(0xFF616161),
      800: Color(0xFF424242),
      900: Color(0xFF212121),
    },
  );

  static const Color mainColor = Color(0xFF89dad0);
  static const Color iconColor1 = Color(0xFFffd28d);
  static const Color iconColor2 = Color(0xFFfcab88);
  static const Color paraColor = Color(0xFF8f837f);
  static const Color buttonBackGroundColor = Color(0xFFf7f6f4);
  static const Color signColor = Color(0xFFa9a29f);
  static const Color titleColor = Color(0xFF5c524f);
  static const Color mainBlackColor = Color(0xFF332d2b);
  static const Color yellowcolorColor = Color(0xFFffd379);

  static const Color logo = Colors.black38;
  static const Color logo1 = Color(0xff353434);
  static const Color logo2 = Color(0xff252525);
  static const Color logo3 = Color(0xff252525);

  static MaterialColor mycolor = const MaterialColor(
    0xff252525,
    <int, Color>{
      50: Color(0xff252525),
      100: Color(0xff252525),
      200: Color(0xff252525),
      300: Color(0xff252525),
      400: Color(0xff252525),
      500: Color(0xff252525),
      600: Color(0xff252525),
      700: Color(0xff252525),
      800: Color(0xff252525),
      900: Color(0xff252525),
    },
  );
}
