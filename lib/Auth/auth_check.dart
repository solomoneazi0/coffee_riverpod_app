import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_files/auth/login_screen.dart';
import 'package:riverpod_files/screens/home/home_screen.dart';
import 'package:riverpod_files/providers/cart_provider.dart';
import 'package:riverpod_files/providers/wishlist_provider.dart';

class AuthCheck extends ConsumerStatefulWidget {
  const AuthCheck({super.key});

  @override
  ConsumerState<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends ConsumerState<AuthCheck> {
  bool _hasLoadedUserData = false;

  Future<void> _loadUserData() async {
    // Load saved cart & wishlist from Supabase
    await ref.read(cartProvider.notifier).loadCartFromSupabase();
    await ref.read(wishlistProvider.notifier).loadWishlistFromSupabase();
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = supabase.auth.currentSession;

        // ⏳ While auth state is loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // USER LOGGED IN
        if (session != null) {
          // Load user data ONLY ONCE
          if (!_hasLoadedUserData) {
            _hasLoadedUserData = true;
            _loadUserData();
          }

          return const HomeScreen();
        }

        // USER LOGGED OUT → clear local state
        _hasLoadedUserData = false;
        ref.read(cartProvider.notifier).clear();
        ref.read(wishlistProvider.notifier).clear();

        return const SigninScreen();
      },
    );
  }
}
