import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_files/providers/cart_provider.dart';

class WelcomeHeader extends ConsumerWidget {
  final String userName;
  final String imagePath;
  final VoidCallback? onCartTap;

  const WelcomeHeader({
    super.key,
    required this.userName,
    required this.imagePath,
    this.onCartTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartCountProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            // color: const Color(0xFFFFF8EE),
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/profile-photo.png'),
                        fit: BoxFit.cover,
                      ),
                      border:
                          Border.all(color: const Color(0xFF183A2F), width: 1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Welcome\n$userName!',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ],
              ),

              // Right icon with cart counter
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
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          constraints:
                              const BoxConstraints(minWidth: 20, minHeight: 20),
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
            ]),
      ),
    );
  }
}
