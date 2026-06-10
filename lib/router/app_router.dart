import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/add_note_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/products_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/video_screen.dart';
import '../models/note_model.dart';
import '../screens/dummy_login_screen.dart';
import '../screens/add_product_screen.dart';
import '../screens/search_products_screen.dart';
import '../screens/search_product_detail_screen.dart';
import '../screens/new_page.dart';
import '../screens/update_product_screen.dart';
import '../screens/delete_product_screen.dart';



class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',

    // Auth redirect — agar login nahi to login page
    redirect: (context, state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      return null;
    },

    routes: [
      // Splash
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Login
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Register
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
  path: '/dummy-login',
  builder: (context, state) => const DummyLoginScreen(),
),

      // Home
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),

            GoRoute(
        path: '/add-product',
        builder: (context, state) => const AddProductScreen(),
      ),

GoRoute(
  path: '/update-product',
  builder: (context, state) {
    // Receive product id from add screen
    final productId = state.extra as String?;
    return UpdateProductScreen(productId: productId);
  },
),
GoRoute(
  path: '/delete-product',
  builder: (context, state) => const DeleteProductScreen(),
),
      // Add / Edit Note
      GoRoute(
        path: '/add-note',
        builder: (context, state) {
          final note = state.extra as NoteModel?;
          return AddNoteScreen(existingNote: note);
        },
      ),
      GoRoute(
  path: '/search-products',
  builder: (context, state) => const SearchProductScreen(),
),


      // Profile
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductsScreen(),
      ),
      // Products List
      GoRoute(
        path: '/new-page',
        builder: (context, state) => const NewPage(),
      ),
            GoRoute(
        path: '/video',
        builder: (context, state) => const VideoScreen(),
      ),

      GoRoute(
  path: '/search-product-detail',
  builder: (context, state) {
    final product = state.extra as Map<String, dynamic>;
    return SearchProductDetailScreen(product: product);
  },
),

      // Product Detail
      GoRoute(
        path: '/product-detail',
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductDetailScreen(product: product);
        },
      ),
    ],
  );
}