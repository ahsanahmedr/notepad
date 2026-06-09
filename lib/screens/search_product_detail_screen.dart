import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'package:go_router/go_router.dart';

class SearchProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const SearchProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Get images list, fallback to thumbnail
    final images = (product['images'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [product['thumbnail'] ?? ''];

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Product Detail',
          style: TextStyle(
              color: AppColors.dark,
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
              ],
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.dark, size: 16),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: Image.network(
    images[0],
    width: double.infinity,
    height: 240,
    fit: BoxFit.cover,

    // ✅ LOADING STATE
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;

      return Container(
        width: double.infinity,
        height: 240,
        color: AppColors.bg,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    },

    // ❌ ERROR STATE
    errorBuilder: (context, error, stackTrace) =>
        Container(
      width: double.infinity,
      height: 240,
      color: AppColors.bg,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.muted,
        size: 40,
      ),
    ),
  ),
),
            const SizedBox(height: 20),

            // Title
            Text(
              product['title'] ?? '',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.dark),
            ),
            const SizedBox(height: 8),

            // Category + Rating row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product['category'] ?? '',
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.star_rounded,
                    color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${product['rating'] ?? ''}',
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.muted,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Price
            Text(
              '\$${product['price']}',
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary),
            ),
            const SizedBox(height: 16),

            // Description
            const Text('Description',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.dark)),
            const SizedBox(height: 6),
            Text(
              product['description'] ?? '',
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.muted,
                  height: 1.6),
            ),
            const SizedBox(height: 16),

            // Stock info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12)
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _infoItem('Stock', '${product['stock']}'),
                  _infoItem('Brand', '${product['brand'] ?? 'N/A'}'),
                  _infoItem('Discount',
                      '${product['discountPercentage']}%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Info item widget
  Widget _infoItem(String label, String value) => Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.dark)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.muted)),
        ],
      );
}