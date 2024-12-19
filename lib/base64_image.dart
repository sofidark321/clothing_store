import 'dart:convert';
import 'package:flutter/material.dart';

class Base64Image extends StatelessWidget {
  final String base64String;
  final double? width;
  final double? height;
  final BoxFit fit;

  const Base64Image({
    Key? key,
    required this.base64String,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  bool _isValidUrl(String str) {
    try {
      final uri = Uri.parse(str);
      return uri.scheme == 'http' || uri.scheme == 'https';
    } catch (e) {
      return false;
    }
  }

  Widget _buildErrorContainer() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.image_not_supported, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      // Vérifie si c'est une URL
      if (_isValidUrl(base64String)) {
        return Image.network(
          base64String,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _buildErrorContainer(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: width,
              height: height,
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
        );
      }

      // Traitement base64
      String cleanBase64 = base64String;
      if (base64String.contains('data:image')) {
        cleanBase64 = base64String.split(',')[1];
      }

      return Image.memory(
        base64Decode(cleanBase64),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildErrorContainer(),
      );
    } catch (e) {
      return _buildErrorContainer();
    }
  }
}