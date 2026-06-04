// ignore_for_file: avoid_print, non_constant_identifier_names, deprecated_member_use, duplicate_ignore

import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsappUrl {
  static const String contact = '7021251102';
  
  static String get androidUrl => 
      Platform.isAndroid 
          ? "whatsapp://send?phone=+91$contact&text=${Uri.encodeComponent('Hi, I need some help')}"
          : "https://api.whatsapp.com/send?phone=91$contact&text=${Uri.encodeComponent('Hi, I need some help')}";
  
  static String get iosUrl => 
      "https://api.whatsapp.com/send?phone=91$contact&text=${Uri.encodeComponent('Hi, I need some help')}";

  static Future<void> reachUs() async {
    try {
      final url = Platform.isIOS ? iosUrl : androidUrl;
      final uri = Uri.parse(url);
      
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        Fluttertoast.showToast(msg: 'Could not launch WhatsApp');
      }
    } catch (e) {
      print('Error launching WhatsApp: $e');
      Fluttertoast.showToast(msg: 'Error launching WhatsApp');
    }
  }

  static Future<void> launchWhatsapp({
    required String number,
    required String message,
  }) async {
    try {
      final cleanNumber = number.replaceAll('+', '').replaceAll(' ', '');
      
      final url = Platform.isAndroid
          ? "whatsapp://send?phone=$cleanNumber&text=${Uri.encodeComponent(message)}"
          : "https://api.whatsapp.com/send?phone=$cleanNumber&text=${Uri.encodeComponent(message)}";
      
      final uri = Uri.parse(url);
      
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        Fluttertoast.showToast(msg: 'Could not launch WhatsApp');
      }
    } catch (e) {
      print('Error launching WhatsApp: $e');
      Fluttertoast.showToast(msg: 'Error launching WhatsApp');
    }
  }
}
