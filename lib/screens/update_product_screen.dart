import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/product_field.dart';

class UpdateProductScreen extends StatefulWidget {
  final String? productId; // received from add screen
  const UpdateProductScreen({super.key, this.productId});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}
class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final _idController = TextEditingController();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _response;

  @override
void initState() {
  super.initState();
  // Auto fill id if coming from add screen
  if (widget.productId != null) {
    _idController.text = widget.productId!;
  }
}

  // Update product by ID using PUT request
  Future<void> _updateProduct() async {
    
    FocusScope.of(context).unfocus();

    // Validate all fields
    if (_idController.text.isEmpty ||
        _titleController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please fill all fields'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      return;
    }

    setState(() {
      _isLoading = true;
      _response = null;
    });

    try {
      // Send PUT request to update product
      final res = await http.put(
        Uri.parse('https://dummyjson.com/products/${_idController.text.trim()}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': _titleController.text.trim(),
          'price': double.tryParse(_priceController.text.trim()) ?? 0,
          'category': _categoryController.text.trim(),
        }),
      );

      final data = jsonDecode(res.body);

      // Check if product not found
      if (res.statusCode != 200) {
        throw Exception(data['message'] ?? 'Product not found');
      }

      setState(() => _response = data);

if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: const Text('Product updated successfully!'),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ));

  // Wait for snackbar then pop with updated data
  // Wait for snackbar then pop with updated data
await Future.delayed(const Duration(milliseconds: 800));
FocusScope.of(context).unfocus();
await Future.delayed(const Duration(milliseconds: 200));
if (mounted) context.pop(data);
}
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
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
          'Update Product',
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

            // Product ID field (1 to 194 valid)
            ProductField(
              controller: _idController,
              
              label: 'Product ID',
              hint: 'e.g. 1  (valid: 1 - 194)',
              icon: Icons.tag_rounded,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),

            // New title
            ProductField(
              controller: _titleController,
              label: 'New Title',
              hint: 'e.g. iPhone Galaxy +1',
              icon: Icons.title_rounded,
            ),
            const SizedBox(height: 14),

            // New price
            ProductField(
              controller: _priceController,
              label: 'New Price',
              hint: 'e.g. 999',
              icon: Icons.attach_money_rounded,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),

            // New category
            ProductField(
              controller: _categoryController,
              label: 'New Category',
              hint: 'e.g. smartphones',
              icon: Icons.category_outlined,
            ),
            const SizedBox(height: 28),

            // Submit button
            CustomButton(
              text: 'Update Product',
              isLoading: _isLoading,
              onPressed: _updateProduct,
              unfocusOnTap: true,
            ),

            // Response card — shown after successful update
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
                    // Success header

                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 14),

                    // Updated product details
                    _row('ID', '${_response!['id']}'),
                    _row('Title', '${_response!['title']}'),
                    _row('Price', '\$${_response!['price']}'),
                    _row('Category', '${_response!['category']}'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Reusable key-value row widget
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
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.dark,
              ),
            ),
          ],
        ),
      );
}