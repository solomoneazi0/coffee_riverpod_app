import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_files/models/product.dart';

class CartStateNotifier extends StateNotifier<List<Product>> {
  CartStateNotifier() : super([]);

  void addProduct(Product product) {
    final exists = state.any((p) => p.id == product.id);
    if (!exists) {
      state = [...state, product];
    }
  }

  void removeProduct(Product product) {
    state = state.where((p) => p.id != product.id).toList();
  }

  void clear() => state = [];
}

final cartProvider = StateNotifierProvider<CartStateNotifier, List<Product>>(
  (ref) => CartStateNotifier(),
);

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0.0, (sum, p) => sum + p.price);
});

final cartCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.length;
});
