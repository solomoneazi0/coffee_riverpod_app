import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_files/components/star_rating_view.dart';
import 'package:riverpod_files/models/product.dart';
import 'package:riverpod_files/models/product_review.dart';
import 'package:riverpod_files/providers/cart_provider.dart';
import 'package:riverpod_files/providers/reviews_provider.dart';
import 'package:riverpod_files/providers/wishlist_provider.dart';
import 'package:riverpod_files/screens/cart/cart_screen.dart';

class ProductDetail extends ConsumerStatefulWidget {
  final Product product;
  final VoidCallback? onCartTap;

  const ProductDetail({
    super.key,
    required this.product,
    this.onCartTap,
  });

  @override
  ConsumerState<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends ConsumerState<ProductDetail> {
  final TextEditingController _reviewController = TextEditingController();
  int _selectedRating = 0;
  int _quantity = 1;

  void _increaseQty() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQty() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = ref.watch(cartCountProvider);
    final reviewsAsync = ref.watch(reviewsByProductProvider(widget.product.id));
    final isWishlisted = ref.watch(isWishlistedProvider(widget.product));

    return Scaffold(
      backgroundColor: const Color(0xFFFCF8F2),

      // ================= BODY =================
      body: SafeArea(
        child: Column(
          children: [
            // ---------- HEADER ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CartScreen(),
                        ),
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          color: const Color(0xFF183A2F),
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
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ---------- SCROLLABLE ----------
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            widget.product.image,
                            height: 320,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 140,
                          right: 240,
                          child: GestureDetector(
                              onTap: () {
                                final wishlist =
                                    ref.read(wishlistProvider.notifier);

                                if (isWishlisted) {
                                  wishlist.remove(widget.product);
                                } else {
                                  wishlist.add(widget.product);
                                }
                              },
                              child: Container(
                                height: 45,
                                width: 45,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isWishlisted
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isWishlisted
                                      ? Colors.redAccent
                                      : Colors.redAccent,
                                ),
                              )),
                        )
                      ],
                    ),

                    const SizedBox(height: 32),

                    // TITLE / PRICE / RATING
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${widget.product.price}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF183A2F),
                                fontFamily: 'Archivo',
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            StarRatingView(
                              rating: widget.product.rating ??
                                  const StarRating(value: 0),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '(${widget.product.reviews} Reviews)',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // DESCRIPTION
                    const Text(
                      'Description',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.description.isNotEmpty
                          ? widget.product.description
                          : 'Carefully sourced from trusted growers and roasted in small batches, this coffee is crafted to showcase balance, clarity, and natural sweetness. With tasting notes of chocolate, caramel, and a hint of citrus, it’s the perfect cup to start your day or enjoy any time you need a moment of calm.',
                      style: const TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: Color.fromARGB(221, 49, 49, 49),
                          fontFamily: 'Archivo'),
                    ),

                    const SizedBox(height: 24),

                    // REVIEWS

// ---------- ADD REVIEW ----------
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add a review',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ⭐ Rating selector
                        Row(
                          children: List.generate(5, (index) {
                            final starIndex = index + 1;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRating = starIndex;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 4), // 👈 control spacing here
                                child: Icon(
                                  starIndex <= _selectedRating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 24,
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 16),

                        // ✍️ Text input (NO BORDER RADIUS)
                        TextField(
                          controller: _reviewController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Write your review...',
                            hintStyle: TextStyle(fontFamily: 'Archivo'),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.zero, // 👈 no radius
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: Colors.black12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            contentPadding: EdgeInsets.all(12),
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'Reviews',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        reviewsAsync.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (_, __) => const Text(
                            'Failed to load reviews',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          data: (reviews) {
                            if (reviews.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  'No reviews yet',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                      fontFamily: 'Archivo'),
                                ),
                              );
                            }

                            return Column(
                              children: reviews
                                  .map((r) => _ReviewTile(review: r))
                                  .toList(),
                            );
                          },
                        ),

                        const SizedBox(height: 12),

                        // 🚀 Submit button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF183A2F),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              if (_reviewController.text.isEmpty ||
                                  _selectedRating == 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Please add rating and review'),
                                  ),
                                );
                                return;
                              }

                              // 🔜 Next step: send to Supabase
                              debugPrint('Rating: $_selectedRating');
                              debugPrint('Review: ${_reviewController.text}');
                            },
                            child: const Text(
                              'Submit Review',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ================= BOTTOM BAR =================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 54,
              width: MediaQuery.of(context).size.width * 0.32,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ➖ Minus
                  GestureDetector(
                    onTap: _decreaseQty,
                    child: const Icon(Icons.remove),
                  ),

                  //  Quantity value
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: 32,
                      height: 28,
                      alignment: Alignment.center,
                      decoration:
                          const BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ]),
                      child: Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // ➕ Plus
                  GestureDetector(
                    onTap: _increaseQty,
                    child: Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE2673D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {
                  final cart = ref.read(cartProvider.notifier);
                  cart.addProduct(widget.product, quantity: _quantity);
                  if (widget.onCartTap != null) {
                    widget.onCartTap!();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added to cart'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ProductReview review;

  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(review.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < review.rating ? Icons.star : Icons.star_border,
                    size: 16,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(review.comment),
          const SizedBox(height: 6),
          Text(
            review.createdAt.toLocal().toString().split(' ').first,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
