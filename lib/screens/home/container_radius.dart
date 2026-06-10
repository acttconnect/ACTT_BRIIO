

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../utils/cart_order.dart';

class RoundedContainer extends StatelessWidget {
  final String? image;
  final Widget? child;
  final double? height;
  final double? width;
  final dynamic onTap;
  final Color? color;
  final String? networkImg;
  final EdgeInsetsGeometry? padding;
  final double? opacity;
  final Color? borderColor;
  final bool isImage;
  RoundedContainer({
    super.key,
    this.image,
    this.child,
    this.height,
    this.width,
    this.padding,
    this.onTap,
    this.opacity,
    this.color,
    this.networkImg,
    this.borderColor,
    required this.isImage,
  });
  final c = Get.put(MyController());
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: borderColor ?? Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            if (image != null)
              Positioned.fill(
                child: Opacity(
                  opacity: opacity ?? 0.6,
                  child: Image.asset(
                    image!,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else if (networkImg != null)
              Positioned.fill(
                child: Opacity(
                  opacity: opacity ?? 1.0,
                  child: CachedNetworkImage(
                    imageUrl: networkImg!,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.image_not_supported, color: Colors.grey, size: 30),
                      ),
                    ),
                  ),
                ),
              ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: padding ?? EdgeInsets.zero,
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
