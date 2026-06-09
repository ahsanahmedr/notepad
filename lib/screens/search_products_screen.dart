import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/app_colors.dart';
import 'package:go_router/go_router.dart';


class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  final _searchController = TextEditingController();
  bool _isLoading = false;
  List<dynamic> _products = [];
  bool _searched = false;

  // Fetch products from API based on search query
Future<void> _searchProducts([String? value]) async {
  final query = value ?? _searchController.text.trim();

    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _products = [];
      _searched = true;
    });

    try {
      final res = await http.get(
        Uri.parse('https://dummyjson.com/products/search?q=$query'),
      );
      final data = jsonDecode(res.body);
      setState(() => _products = data['products']);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Search Products',
          style: TextStyle(
            color: AppColors.dark,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.dark, size: 16),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
  if (value.trim().length > 1) {
    _searchProducts();
  }
},
onSubmitted: (_) => _searchProducts(),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.dark),
                      decoration: InputDecoration(
                        hintText: 'Search e.g. phone, laptop...',
                        hintStyle: const TextStyle(
                            color: AppColors.muted, fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: AppColors.muted),
                        filled: true,
                        fillColor: AppColors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Search button
                GestureDetector(
                  onTap: _searchProducts,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.search_rounded,
                        color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary))
                : !_searched
                    ? const Center(
                        child: Text(
                          'Search for a product',
                          style: TextStyle(
                              color: AppColors.muted, fontSize: 15),
                        ),
                      )
                    : _products.isEmpty
                        ? const Center(
                            child: Text(
                              'No products found',
                              style: TextStyle(
                                  color: AppColors.muted, fontSize: 15),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _products.length,
                            itemBuilder: (_, i) {
                              final p = _products[i];
                              
                              return GestureDetector(
  onTap: () => context.push(
    '/search-product-detail',
    extra: p,
  ),
                             child:  Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.04),
                                      blurRadius: 12,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Product image
ClipRRect(
  borderRadius: BorderRadius.circular(10),
  child: Stack(
    children: [
      // IMAGE
      Image.network(
        p['thumbnail'] ?? '',
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Container(
          width: 60,
          height: 60,
          color: AppColors.bg,
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: AppColors.muted,
          ),
        ),
      ),

      // LOADER OVER IMAGE
      Positioned.fill(
        child: FutureBuilder(
          future: precacheImage(
            NetworkImage(p['thumbnail'] ?? ''),
            context,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const SizedBox.shrink();
            }

            return Container(
              color: AppColors.bg,
              child: const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          },
        ),
      ),
    ],
  ),
),
                                    const SizedBox(width: 12),

                                    // Product info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            p['title'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.dark,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            p['category'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.muted,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '\$${p['price']}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}