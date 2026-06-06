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

      // Home
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Add / Edit Note
      GoRoute(
        path: '/add-note',
        builder: (context, state) {
          final note = state.extra as NoteModel?;
          return AddNoteScreen(existingNote: note);
        },
      ),

      // Profile
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // Products List
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductsScreen(),
      ),
            GoRoute(
        path: '/video',
        builder: (context, state) => const VideoScreen(),
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