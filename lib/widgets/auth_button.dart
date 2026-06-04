import 'package:flutter/material.dart';

import '../utils/colors.dart';

class AuthButton {
  static Widget authButton(
      {required String text,
      onPressed,
      context,
      Color btnColor = AppColors.buttonBackGroundColor,
      Color textColor = AppColors.mainBlackColor}) {
    return MaterialButton(
        color: const Color(0xFF353434),
        padding: const EdgeInsets.symmetric(vertical: 10),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18, color: textColor, ),
        ),
      );
  }
}
