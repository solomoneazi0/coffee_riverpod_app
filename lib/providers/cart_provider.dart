import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_files/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

class CartStateNotifier extends StateNotifier<List<Product>> {
  CartStateNotifier() : super([]);

  final SupabaseClient _supabase = Supabase.instance.client;

  // ================= LOAD CART FROM SUPABASE =================
  Future<void> loadCartFromSupabase() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      debugPrint('loadCartFromSupabase: no user');
      return;
    }

    try {
      debugPrint('⬇️ Loading cart from Supabase');

      final response = await _supabase
          .from('cart_items')
          .select('product')
          .eq('user_id', user.id);

      state = response
          .map<Product>((row) => Product.fromJson(row['product']))
          .toList();

      debugPrint('✅ Cart loaded: ${state.length} items');
    } catch (e) {
      debugPrint('Failed to load cart: $e');
    }
  }

  // ================= ADD PRODUCT =================
  Future<void> addProduct(Product product, {required int quantity}) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      debugPrint('addProduct: no user');
      return;
    }

    final exists = state.any((p) => p.id == product.id);
    if (exists) {
      debugPrint('Product already in cart');
      return;
    }

    try {
      debugPrint('Adding product to cart');

      await _supabase.from('cart_items').insert({
        'user_id': user.id,
        'product_id': product.id,
        'quantity': quantity,
        'product': {
          'id': product.id,
          'title': product.title,
          'price': product.price,
          'image': product.image,
          'category': product.category.name,
          'description': product.description,
          'reviews': product.reviews,
          'tags': product.tags.map((e) => e.name).toList(),
          'rating': product.rating?.value,
        },
      });

      state = [...state, product];

      debugPrint('✅ Product added to cart');
    } catch (e) {
      debugPrint('Failed to add product: $e');
    }
  }

  // ================= REMOVE PRODUCT =================
  Future<void> removeProduct(Product product) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      debugPrint('removeProduct: no user');
      return;
    }

    try {
      debugPrint('Removing product from cart');

      await _supabase
          .from('cart_items')
          .delete()
          .eq('user_id', user.id)
          .eq('product_id', product.id);

      state = state.where((p) => p.id != product.id).toList();

      debugPrint('✅ Product removed');
    } catch (e) {
      debugPrint('Failed to remove product: $e');
    }
  }

  // ================= CLEAR CART =================
  Future<void> clearCart() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      debugPrint('ClearCart: no user');
      return;
    }

    try {
      debugPrint('Clearing cart');

      await _supabase.from('cart_items').delete().eq('user_id', user.id);

      state = [];

      debugPrint('Cart cleared');
    } catch (e) {
      debugPrint('Failed to clear cart: $e');
    }
  }

  void clear() {}
}

// ================= PROVIDERS =================

final cartProvider = StateNotifierProvider<CartStateNotifier, List<Product>>(
  (ref) => CartStateNotifier(),
);

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold<double>(0.0, (sum, p) => sum + p.price);
});

final cartCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).length;
});

final isInCartProvider = Provider.family<bool, Product>((ref, product) {
  return ref.watch(cartProvider).any((p) => p.id == product.id);
});
