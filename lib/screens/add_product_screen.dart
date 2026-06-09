import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/product_field.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _response;

  

  Future<void> _addProduct() async {
    FocusScope.of(context).unfocus();
    if (_titleController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please fill all fields'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      return;
    }
    setState(() { _isLoading = true; _response = null; });
    try {
      final res = await http.post(
        Uri.parse('https://dummyjson.com/products/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': _titleController.text.trim(),
          'price': double.tryParse(_priceController.text.trim()) ?? 0,
          'category': _categoryController.text.trim(),
        }),
      );
      setState(() => _response = jsonDecode(res.body));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Product added successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
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
    _titleController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, 
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text('Add Product',
            style: TextStyle(color: AppColors.dark, fontWeight: FontWeight.w700, fontSize: 18)),
        leading: GestureDetector(
          onTap: () => context.go('/new-page'),
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.dark, size: 16),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            ProductField(controller: _titleController, label: 'Title', hint: 'e.g. BMW Pencil', icon: Icons.title_rounded),
            const SizedBox(height: 14),
            ProductField(controller: _priceController, label: 'Price', hint: 'e.g. 10', icon: Icons.attach_money_rounded, keyboardType: TextInputType.number),
            const SizedBox(height: 14),
            ProductField(controller: _categoryController, label: 'Category', hint: 'e.g. stationery', icon: Icons.category_outlined, autofocus: false,),
            const SizedBox(height: 28),
            CustomButton(text: 'Save Product', isLoading: _isLoading, onPressed: _addProduct),
            if (_response != null) ...[
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12)],
                ),
                child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(children: [
      Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.check_rounded, color: Colors.green, size: 18),
      ),
      const SizedBox(width: 10),
      const Text('Product Added!',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.dark)),
      const Spacer(),

      // Edit button — navigate to update screen with product id
      GestureDetector(
       // Receive updated data from update screen
onTap: () async {
  // Dismiss keyboard before navigating
  FocusScope.of(context).unfocus();
  await Future.delayed(const Duration(milliseconds: 300));
  
  final updated = await context.push<Map<String, dynamic>>(
    '/update-product',
    extra: _response!['id'].toString(),
  );
  if (updated != null) {
    setState(() => _response = updated);
  }
},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.edit_rounded, size: 13, color: Colors.orange),
              SizedBox(width: 4),
              Text(
                'Edit',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ]),
    const SizedBox(height: 14),
    const Divider(height: 1),
    const SizedBox(height: 14),
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

  Widget _row(String key, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(children: [
      Text('$key: ', style: const TextStyle(fontSize: 13, color: AppColors.muted, fontWeight: FontWeight.w500)),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.dark)),
    ]),
  );
}