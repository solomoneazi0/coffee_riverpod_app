import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_files/components/checkout_bottom.dart';
import 'package:riverpod_files/providers/address_providers.dart';
import 'package:riverpod_files/providers/cart_provider.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);
    final addressController = TextEditingController();
    final TextEditingController promoController = TextEditingController();

    final savedAddress = ref.watch(addressProvider);

    if (savedAddress != null && addressController.text.isEmpty) {
      addressController.text = savedAddress;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ENTER ADDRESS
            ///
            ///
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Delivery Address",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      hintText: "Enter your delivery address",
                      fillColor: Colors.white,
                      filled: true,
                      hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontFamily: 'archivo'),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      suffixIcon: addressController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () {
                                ref
                                    .read(addressProvider.notifier)
                                    .saveAddress(addressController.text);
                                addressController.clear();
                              },
                            )
                          : null),
                ),
              ],
            ),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  /// TEXT FIELD
                  Expanded(
                    child: TextField(
                      controller: promoController,
                      decoration: const InputDecoration(
                        hintText: "Promo Code",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  /// REDEEM BUTTON
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      // apply promo later
                    },
                    child: const Text(
                      "Redeem",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Your Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            /// CART ITEMS
            Expanded(
                child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// PRODUCT IMAGE
                          Container(
                            width: 60,
                            height: 60,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(
                              product.image,
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// PRODUCT INFO
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// PRODUCT NAME
                                Text(
                                  product.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                /// QUANTITY CONTROLS
                                Row(
                                  children: [
                                    /// ADD BUTTON
                                    GestureDetector(
                                      onTap: () {
                                        ref
                                            .read(cartProvider.notifier)
                                            .addProduct(product, quantity: 1);
                                      },
                                      child: Container(
                                        width: 26,
                                        height: 26,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                        ),
                                        child: const Icon(Icons.add, size: 16),
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    const Text(
                                      "1",
                                      style: TextStyle(fontSize: 15),
                                    ),

                                    const SizedBox(width: 10),

                                    /// REMOVE BUTTON
                                    GestureDetector(
                                      onTap: () {
                                        ref
                                            .read(cartProvider.notifier)
                                            .removeProduct(product);
                                      },
                                      child: Container(
                                        width: 26,
                                        height: 26,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                        ),
                                        child:
                                            const Icon(Icons.remove, size: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          /// PRODUCT PRICE
                          Text(
                            "\$${product.price}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                );
              },
            )),
          ],
        ),
      ),
      bottomNavigationBar: CheckoutBottomBar(subtotal: total),
    );
  }
}
