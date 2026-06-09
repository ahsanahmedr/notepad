import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              // SEARCH BUTTON
SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
      context.push('/search-products');
    },
    icon: const Icon(
      Icons.search,
      color: Colors.white,
      size: 20,
    ),
    label: const Text(
      'Search Products',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1A1A2E),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),
),
          SizedBox(height: 16),
              // BAG BUTTON
            SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
      context.push('/products');
    },
    icon: const Icon(
      Icons.shopping_bag_outlined,
      color: Colors.white,
      size: 20,
    ),
    label: const Text(
      'Products',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1A1A2E),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),
),
          SizedBox(height: 16),
              // VIDEO BUTTON
           SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
      context.push('/video');
    },
    icon: const Icon(
      Icons.play_circle_outline_rounded,
      color: Colors.white,
      size: 20,
    ),
    label: const Text(
      'Watch Video',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1A1A2E),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    ),
  ),
),              const SizedBox(height: 16),
              SizedBox(
  width: double.infinity,
  height: 52,
  child: ElevatedButton.icon(
    onPressed: () {
      context.push('/dummy-login');
    },
    icon: const Icon(Icons.api_rounded,
        color: Colors.white, size: 20),
    label: const Text(
      'DummyJSON Login',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1A1A2E),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
),
                        const SizedBox(height: 16),
              SizedBox(
  width: double.infinity,
  height: 52,
  child: ElevatedButton.icon(
    onPressed: () {
      context.go('/add-product');
    },
    icon: const Icon(Icons.api_rounded,
        color: Colors.white, size: 20),
    label: const Text(
      'Addproduct',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1A1A2E),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
),


            ],
          ),
        ),
      ),
    );
  }
}