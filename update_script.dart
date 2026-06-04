import 'dart:io';

void processAuthFile(String path) {
  var file = File(path);
  if (!file.existsSync()) return;
  
  var content = file.readAsStringSync();
  bool modified = false;

  // Ensure imports
  if (!content.contains("import 'package:briio_application/widgets/custom_loading.dart';")) {
    content = content.replaceFirst(
      "import 'package:flutter/material.dart';",
      "import 'package:flutter/material.dart';\nimport 'package:briio_application/widgets/custom_loading.dart';"
    );
    modified = true;
  }
  
  if (!content.contains("import 'package:briio_application/utils/colors.dart';") && !content.contains("import '../../utils/colors.dart';")) {
    content = content.replaceFirst(
      "import 'package:flutter/material.dart';",
      "import 'package:flutter/material.dart';\nimport 'package:briio_application/utils/colors.dart';"
    );
    modified = true;
  }

  // Replace colors
  if (content.contains("Color(0xFF353434)")) {
    content = content.replaceAll("Color(0xFF353434)", "AppColors.titleColor");
    modified = true;
  }
  
  // Replace CircularProgressIndicator inside SizedBox (button loading)
  if (content.contains("CircularProgressIndicator(")) {
    // Some are like: CircularProgressIndicator(color: AppColors.titleColor, strokeWidth: 2.5)
    content = content.replaceAll(RegExp(r'CircularProgressIndicator\([^)]*\)'), "CustomLoading(width: 30, height: 30)");
    content = content.replaceAll("CircularProgressIndicator()", "CustomLoading(width: 30, height: 30)");
    modified = true;
  }

  if (modified) {
    file.writeAsStringSync(content);
    print('Updated \$path');
  }
}

void processMainCategoryScreen() {
  var file = File('lib/screens/pages/categories/main_category_screen.dart');
  var content = file.readAsStringSync();
  
  content = content.replaceAll(
    'padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),',
    'padding: EdgeInsets.zero,',
  );
  
  content = content.replaceAll(
    'ListView.separated(',
    'ListView.builder(',
  );
  
  content = content.replaceAll(
    'separatorBuilder: (context, index) => const SizedBox(height: 16),',
    '',
  );
  
  content = content.replaceAll(
    'height: 160,',
    'height: MediaQuery.of(context).size.height / 3.3, // take approx 1/3 of screen space',
  );
  
  // Remove border radius
  content = content.replaceAll('borderRadius: BorderRadius.circular(16),', 'borderRadius: BorderRadius.zero,');
  
  file.writeAsStringSync(content);
  print('Updated main_category_screen.dart');
}

void main() {
  processAuthFile('lib/screens/auth/sign_in.dart');
  processAuthFile('lib/screens/auth/sign_up.dart');
  processAuthFile('lib/screens/auth/forgot_pass.dart');
  processAuthFile('lib/screens/auth/otp_verification.dart');
  processAuthFile('lib/screens/auth/create_new_password.dart');
  
  processMainCategoryScreen();
}
