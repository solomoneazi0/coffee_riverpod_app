import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_files/models/product.dart';
import 'package:riverpod_files/providers/products_provider.dart';

class ProductTabs extends ConsumerWidget {
  const ProductTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTag = ref.watch(productTabProvider);

    Widget tab(String title, ProductTag tag) {
      final isActive = selectedTag == tag;

      return GestureDetector(
        onTap: () {
          ref.read(productTabProvider.notifier).state = tag;
        },
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isActive ? 18 : 14, // 👈 active slightly bigger
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              if (isActive)
                Container(
                  height: 2,
                  width: double.infinity, // 👈 matches text width
                  color: Colors.black,
                ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        tab('ALL', ProductTag.all),
        const SizedBox(width: 32),
        tab('NEW ARRIVALS', ProductTag.newArrival),
        const SizedBox(width: 32),
        tab('BEST SELLING', ProductTag.bestSelling),
      ],
    );
  }
}
