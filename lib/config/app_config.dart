import 'package:briio_application/widgets/custom_loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppConfig {
  static void initImageCache() {
    // Set maximum number of images to cache
    PaintingBinding.instance.imageCache.maximumSize = 1000;
    // Set maximum memory usage for image cache (100 MB)
    PaintingBinding.instance.imageCache.maximumSizeBytes = 100 << 20;
  }

  static CachedNetworkImage getOptimizedNetworkImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => 
          placeholder ?? const Center(child: CustomLoading(width: 40, height: 40)),
      errorWidget: (context, url, error) => 
          errorWidget ?? const Icon(Icons.error),
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
      maxWidthDiskCache: 1024,
      maxHeightDiskCache: 1024,
    );
  }
} 