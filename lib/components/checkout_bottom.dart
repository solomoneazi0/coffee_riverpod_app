import 'package:flutter/material.dart';
import 'package:riverpod_files/screens/order_success_screen.dart';

class CheckoutBottomBar extends StatelessWidget {
  final double subtotal;

  const CheckoutBottomBar({
    super.key,
    required this.subtotal,
  });

  @override
  Widget build(BuildContext context) {
    const double shipping = 10;
    const double discount = 10;

    final total = subtotal + shipping - discount;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// SUBTOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Sub Total",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                "\$${subtotal.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),

          /// DASHED LINE
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final dashCount = (constraints.maxWidth / 8).floor();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(dashCount, (_) {
                    return Container(
                      width: 4,
                      height: 1,
                      color: Colors.grey.shade400,
                    );
                  }),
                );
              },
            ),
          ),

          /// SHIPPING
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Shipping",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                "\$10.00",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),

          /// DASHED LINE
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final dashCount = (constraints.maxWidth / 8).floor();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(dashCount, (_) {
                    return Container(
                      width: 4,
                      height: 1,
                      color: Colors.grey.shade400,
                    );
                  }),
                );
              },
            ),
          ),

          /// DISCOUNT
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Discount",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                "-\$10.00",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),

          /// DASHED LINE
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final dashCount = (constraints.maxWidth / 8).floor();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(dashCount, (_) {
                    return Container(
                      width: 4,
                      height: 1,
                      color: Colors.grey.shade400,
                    );
                  }),
                );
              },
            ),
          ),

          /// TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                "\$${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFF0D3122),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// PROCESS BUTTON
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD8A24A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OrderSuccessScreen(),
                  ),
                );
                // create order later
              },
              child: const Text(
                "Process",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
