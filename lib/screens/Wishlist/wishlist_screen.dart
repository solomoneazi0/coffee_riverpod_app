import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_files/components/product_card.dart';
import 'package:riverpod_files/providers/wishlist_provider.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistProducts = ref.watch(wishlistProvider);
    final count = wishlistProducts.length;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF8F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // ================= HEADER ROW =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Wishlist',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$count items',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ================= BODY =================
              Expanded(
                child: wishlistProducts.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 300.0),
                        child: Center(
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.favorite_border,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Your wishlist is empty',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: wishlistProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, index) {
                          final product = wishlistProducts[index];
                          return ProductCard(product: product);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
