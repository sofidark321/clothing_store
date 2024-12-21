import 'package:clothing_store/base64_image.dart';
import 'package:flutter/material.dart';
import '../models/clothing.dart';

import '../widgets/detail_section.dart';
import '../widgets/add_to_cart_button.dart';
import '../theme/app_theme.dart';

class ClothingDetailScreen extends StatelessWidget {
  final Clothing clothing;

  const ClothingDetailScreen({
    super.key,
    required this.clothing,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.lightBlue.withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              // TODO: Implement wishlist functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'clothing-${clothing.title}',
                    child: SizedBox(
                      width: double.infinity,
                      height: 400,
                      child: Base64Image(
                        base64String: clothing.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                clothing.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.yellow,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.yellow.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '€${clothing.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppColors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        DetailSection(
                          icon: Icons.category,
                          label: 'Category',
                          value: clothing.category,
                        ),
                        const SizedBox(height: 12),
                        DetailSection(
                          icon: Icons.straighten,
                          label: 'Size',
                          value: clothing.size,
                        ),
                        const SizedBox(height: 12),
                        DetailSection(
                          icon: Icons.branding_watermark,
                          label: 'Brand',
                          value: clothing.brand,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AddToCartButton(clothing: clothing),
        ],
      ),
    );
  }
}