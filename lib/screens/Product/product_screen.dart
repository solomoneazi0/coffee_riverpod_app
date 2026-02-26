import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_files/components/product_card.dart';
import 'package:riverpod_files/models/product.dart';
import 'package:riverpod_files/providers/products_provider.dart';
import 'package:riverpod_files/components/product_tabs.dart';

class ProductScreen extends ConsumerWidget {
  final Category category;

  const ProductScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(categoryCountProvider(category));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, top: 64),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      category.toName(), // 👈 dynamic category name
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // product count
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
            const SizedBox(height: 24),
            const ProductTabs(),
            const SizedBox(height: 16),
            Expanded(
              child: ref.watch(filteredProductsProvider(category)).isEmpty
                  ? _EmptyState()
                  : GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount:
                          ref.watch(filteredProductsProvider(category)).length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        // shorter aspect ratio gives more vertical space
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        final product = ref
                            .watch(filteredProductsProvider(category))[index];
                        return Stack(
                          children: [
                            ProductCard(product: product),
                            const Positioned(
                              top: 8,
                              right: 8,
                              child: Row(
                                children: [
                                  // Add any overlay widgets here
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No items currently',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
