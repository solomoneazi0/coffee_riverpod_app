import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_files/components/star_rating_view.dart';
import 'package:riverpod_files/models/product.dart';
import 'package:riverpod_files/providers/cart_provider.dart';

class ProductDetail extends ConsumerWidget {
  final VoidCallback? onCartTap;
  final Product product;

  const ProductDetail({
    super.key,
    this.onCartTap,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartCountProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 24,
                    ),
                  ),
                  GestureDetector(
                    onTap: onCartTap,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFF183A2F),
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white,
                          ),
                        ),
                        if (cartCount > 0)
                          Positioned(
                            right: -6,
                            top: -6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                              ),
                              constraints: const BoxConstraints(
                                  minWidth: 20, minHeight: 20),
                              child: Center(
                                child: Text(
                                  '$cartCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Center(
                          child: Image.asset(
                            product.image,
                            height: 360,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // LEFT COLUMN
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${product.price}',
                              style: const TextStyle(
                                fontSize: 36,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        // RIGHT COLUMN
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            StarRatingView(
                              rating:
                                  product.rating ?? const StarRating(value: 0),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '(${product.reviews} Reviews)',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          product.description.isNotEmpty
                              ? product.description
                              : 'Carefully sourced from trusted growers and roasted in small batches, this coffee is crafted to showcase balance, clarity, and natural sweetness.',
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.black87,
                            fontFamily: 'archivo',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80), // space before sticky bar
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
