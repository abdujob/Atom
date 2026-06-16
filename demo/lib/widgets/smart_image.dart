import 'package:flutter/material.dart';

/// Widget intelligent qui affiche une image locale (asset) ou distante (http)
/// selon l'URL fournie.
class SmartImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final int? cacheWidth;
  final int? cacheHeight;

  const SmartImage(
    this.imageUrl, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.cacheWidth,
    this.cacheHeight,
  });

  bool get _isNetwork {
    if (imageUrl.contains('assets/images/')) {
      return false;
    }
    return imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
  }

  String get _localPath {
    if (imageUrl.contains('assets/images/')) {
      final index = imageUrl.indexOf('assets/images/');
      return imageUrl.substring(index);
    }
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    if (_isNetwork) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stack) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
        ),
      );
    } else {
      return Image.asset(
        _localPath,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        errorBuilder: (context, error, stack) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
        ),
      );
    }
  }
}
