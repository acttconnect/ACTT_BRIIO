import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ImageUtils {
  static Future<File> compressImage(File file) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = "${dir.absolute.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg";
    
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      minWidth: 1024,
      minHeight: 1024,
    );
    
    return File(result!.path);
  }

  static Future<List<File>> compressImages(List<File> files) async {
    List<File> compressedFiles = [];
    for (var file in files) {
      final compressed = await compressImage(file);
      compressedFiles.add(compressed);
    }
    return compressedFiles;
  }
} 