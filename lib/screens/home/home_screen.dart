import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_files/components/appbar.dart';
import 'package:riverpod_files/components/category_card.dart';
import 'package:riverpod_files/models/product.dart';
import 'package:riverpod_files/providers/cart_provider.dart';
import 'package:riverpod_files/providers/products_provider.dart';
import 'package:riverpod_files/screens/Product/product_detail_screen.dart';
import 'package:riverpod_files/screens/cart/cart_screen.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.78);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featured = ref.watch(featuredProductsProvider);
    final user = Supabase.instance.client.auth.currentUser;
    final fullName = user?.userMetadata?['full_name'] ?? 'there';
    // final cartItems = ref.watch(cartNotifierProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: WelcomeHeader(
          userName: '$fullName 👋',
          imagePath: 'assets/images/user-profile.jpg',
          onCartTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartScreen(),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          // TOP SECTION (reduced): give the bottom more room.
          Expanded(
            flex: 2,
            child: SizedBox(
              width: double.infinity,
              // color: const Color(0xFFFFF3E0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),

                  // Header label
                  Text(
                    ProductTag.bestSelling.toName(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        fontFamily: 'archivo'),
                  ),

                  const SizedBox(height: 6),

                  // Centered product title (updates with page)
                  if (featured.isNotEmpty)
                    Text(
                      featured[currentIndex].title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0D3122),
                            fontSize: 28,
                          ),
                    ),

                  // Product swiper (reduced height)
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(
                      height: 220,
                      child: Swiper(
                        itemCount: featured.length,
                        viewportFraction: 0.74,
                        scale: 0.5,
                        onIndexChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final product = featured[index];
                          final cartItems = ref.watch(cartProvider);
                          final isInCart =
                              cartItems.any((p) => p.id == product.id);

                          return Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetail(
                                        product: product,
                                        //
                                      ),
                                    ),
                                  );
                                },
                                child: Center(
                                  child: product.image.startsWith('http')
                                      ? Image.network(
                                          product.image,
                                          fit: BoxFit.contain,
                                        )
                                      : Image.asset(
                                          product.image,
                                          fit: BoxFit.contain,
                                        ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                    onTap: () {
                                      final cart =
                                          ref.read(cartProvider.notifier);

                                      if (isInCart) {
                                        cart.removeProduct(product);
                                      } else {
                                        cart.addProduct(product);
                                      }
                                    },
                                    child: Container(
                                      height: 45,
                                      width: 45,
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 232, 255, 246),
                                        // shape: BoxShape.circle,
                                      ),
                                      child: isInCart
                                          ? const Icon(
                                              Icons.remove,
                                              color: Color(0xFF0D3122),
                                              size: 24,
                                            )
                                          : const Icon(
                                              Icons.add,
                                              color: Color(0xFF0D3122),
                                              size: 24,
                                            ),
                                    )),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 🔵 SCROLL INDICATOR (OUTSIDE THE SWIPER)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(featured.length, (index) {
                      final isActive = index == currentIndex;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 12 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF0D3122)
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Other Products ',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'archivo',
                                fontWeight: FontWeight.w500)),

                        Row(
                          children: [
                            Text('See all',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'archivo',
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF69706D))),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios, size: 12),
                          ],
                        )
                        // You can add additional widgets here if needed
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // BOTTOM SECTION: smaller
          // BOTTOM SECTION: scrollable categories
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: const Color(0xFFF1F8E9),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: Category.values.map((category) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: CategoryCard(category: category),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
