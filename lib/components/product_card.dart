import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_files/components/star_rating_view.dart';
import 'package:riverpod_files/models/product.dart';
import 'package:riverpod_files/providers/cart_provider.dart';
import 'package:riverpod_files/screens/Product/product_detail_screen.dart';

class ProductCard extends ConsumerStatefulWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final isInCart = ref.watch(cartProvider).contains(widget.product);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFCF8F2),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ⭐ TOP ROW (rating + add/remove)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StarRatingView(
                rating: widget.product.rating ?? const StarRating(value: 0),
              ),
              GestureDetector(
                onTap: () {
                  final cart = ref.read(cartProvider.notifier);
                  isInCart
                      ? cart.removeProduct(widget.product)
                      : cart.addProduct(widget.product, quantity: 1);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  color: const Color(0xFFE6E6E6),
                  child: Icon(
                    isInCart ? Icons.remove : Icons.add,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 🖼 IMAGE (THIS IS THE KEY FIX)
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetail(
                      product: widget.product,
                    ),
                  ),
                );
              },
              child: Image.asset(
                widget.product.image,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 6),

          // 🏷 TITLE
          Text(
            widget.product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          // 💲 PRICE
          Text(
            '\$${widget.product.price}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
