import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/product_field.dart';

class DeleteProductScreen extends StatefulWidget {
  const DeleteProductScreen({super.key});
  
  @override
  State<DeleteProductScreen> createState() => _DeleteProductScreenState();
}

class _DeleteProductScreenState extends State<DeleteProductScreen> {
  final _idController = TextEditingController();
  final _idFocus = FocusNode();
  bool _isLoading = false;
  Map<String, dynamic>? _response;

  // Send DELETE request to DummyJSON
  Future<void> _deleteProduct() async {
    FocusScope.of(context).unfocus();

    // Validate ID field
    if (_idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please enter a Product ID'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      return;
    }

    // Confirm before delete
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Product',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.dark,
          ),
        ),
        content: Text(
          'Are you sure you want to delete product #${_idController.text}?',
          style: const TextStyle(color: AppColors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.muted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    // User cancelled
    if (confirm != true) return;

    setState(() {
      _isLoading = true;
      _response = null;
      
    });

    try {
      // Send DELETE request
      final res = await http.delete(
        Uri.parse(
            'https://dummyjson.com/products/${_idController.text.trim()}'),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(res.body);

      // Check if product not found
      if (res.statusCode != 200) {
        throw Exception(data['message'] ?? 'Product not found');
      }

      setState(() => _response = data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Product deleted successfully!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _idFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          backgroundColor: AppColors.bg,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            'Delete Product',
            style: TextStyle(
              color: AppColors.dark,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
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
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                  )
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
            children: [
              const SizedBox(height: 8),

              // Product ID field
              ProductField(
                controller: _idController,
                focusNode: _idFocus,
                label: 'Product ID',
                hint: 'e.g. 1  (valid: 1 - 194)',
                icon: Icons.tag_rounded,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: 28),

              // Delete button
              CustomButton(
                text: 'Delete Product',
                isLoading: _isLoading,
                onPressed: _deleteProduct,
                unfocusOnTap: true,
              ),

              // Response card — shown after successful delete
              if (_response != null) ...[
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Delete success header
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.delete_rounded,
                                color: Colors.red, size: 18),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Product Deleted!',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.dark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1),
                      const SizedBox(height: 14),

                      // Deleted product details
                      _row('ID', '${_response!['id']}'),
                      _row('Title', '${_response!['title']}'),
                      _row('Price', '\$${_response!['price']}'),
                      _row('Category', '${_response!['category']}'),
                      _row('Is Deleted', '${_response!['isDeleted']}'),
                      _row('Deleted On', '${_response!['deletedOn']}'),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Reusable key-value row
  Widget _row(String key, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Text(
              '$key: ',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.dark,
                ),
              ),
            ),
          ],
        ),
      );
}