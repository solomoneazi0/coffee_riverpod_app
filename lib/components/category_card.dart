import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_files/models/product.dart';
import 'package:riverpod_files/providers/products_provider.dart';
import 'package:riverpod_files/screens/product/product_screen.dart';

class CategoryCard extends ConsumerWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(categoryCountProvider(category));

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductScreen(category: category),
          ),
        );
      },
      child: Stack(children: [
        Stack(
          clipBehavior: Clip.none,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: category.color,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count items →',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    category.toName().toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Positioned(
          bottom: -100,
          right: -150,
          child: Image.asset(
            'assets/images/catstackimage.png',
            width: 400,
          ),
        ),
      ]),
    );
  }
}
