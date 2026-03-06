import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_files/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

class WishlistStateNotifier extends StateNotifier<List<Product>> {
  WishlistStateNotifier() : super([]);

  final _supabase = Supabase.instance.client;

  // ================= LOAD WISHLIST FROM SUPABASE =================
  Future<void> loadWishlistFromSupabase() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final response = await _supabase
        .from('wishlist_items')
        .select('product')
        .eq('user_id', user.id);

    state = response
        .map<Product>((row) => Product.fromJson(row['product']))
        .toList();
  }

  // ================= ADD TO WISHLIST =================
  Future<void> add(Product product) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final exists = state.any((p) => p.id == product.id);
    if (exists) return;

    // 1️⃣ Save to Supabase
    await _supabase.from('wishlist_items').insert({
      'user_id': user.id,
      'product_id': product.id,
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

    // 2️⃣ Update local state
    state = [...state, product];
  }

  // ================= REMOVE FROM WISHLIST =================
  Future<void> remove(Product product) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    // 1️⃣ Remove from Supabase
    await _supabase
        .from('wishlist_items')
        .delete()
        .eq('user_id', user.id)
        .eq('product_id', product.id);

    // 2️⃣ Update local state
    state = state.where((p) => p.id != product.id).toList();
  }

  // ================= CLEAR WISHLIST =================
  Future<void> clear() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.from('wishlist_items').delete().eq('user_id', user.id);
    state = [];
  }
}

// ================= PROVIDERS =================

final wishlistProvider =
    StateNotifierProvider<WishlistStateNotifier, List<Product>>(
  (ref) => WishlistStateNotifier(),
);

final wishlistCountProvider = Provider<int>((ref) {
  return ref.watch(wishlistProvider).length;
});

final isWishlistedProvider = Provider.family<bool, Product>((ref, product) {
  return ref.watch(wishlistProvider).any((p) => p.id == product.id);
});
