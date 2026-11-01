import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your cart')),
      body: Consumer<CartProvider>(builder: (context, cart, _) {
        if (cart.items.isEmpty)
          return const Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.shopping_bag_outlined, size: 72, color: Colors.grey),
            SizedBox(height: 12),
            Text('Your cart is empty',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Add something delicious to get started.')
          ]));
        return Column(children: [
          Expanded(
              child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: cart.items.values
                      .map((item) => Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(item.food.imageUrl,
                                          width: 76,
                                          height: 76,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const SizedBox(
                                                  width: 76,
                                                  height: 76,
                                                  child:
                                                      Icon(Icons.fastfood)))),
                                  const SizedBox(width: 12),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Text(item.food.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 6),
                                        Text(
                                            '₹${item.food.price.toStringAsFixed(0)} each'),
                                        Text(
                                            '₹${item.total.toStringAsFixed(0)}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFFF6B35)))
                                      ])),
                                  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            onPressed: () =>
                                                cart.decrement(item.food.id),
                                            icon: const Icon(
                                                Icons.remove_circle_outline)),
                                        Text('${item.quantity}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        IconButton(
                                            onPressed: () =>
                                                cart.add(item.food),
                                            icon: const Icon(
                                                Icons.add_circle_outline))
                                      ]),
                                ])),
                          ))
                      .toList())),
          Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(22))),
              child: Column(children: [
                _PriceRow(label: 'Subtotal', value: cart.subtotal),
                _PriceRow(label: 'Delivery fee', value: cart.deliveryFee),
                _PriceRow(label: 'Tax (5%)', value: cart.tax),
                const Divider(height: 22),
                _PriceRow(label: 'Total', value: cart.total, bold: true),
                const SizedBox(height: 12),
                SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CheckoutScreen())),
                        child: const Text('Proceed to checkout'))),
              ])),
        ]);
      }),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow(
      {required this.label, required this.value, this.bold = false});
  final String label;
  final double value;
  final bool bold;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Expanded(
            child: Text(label,
                style: TextStyle(
                    fontWeight: bold ? FontWeight.bold : FontWeight.normal))),
        Text('₹${value.toStringAsFixed(2)}',
            style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                fontSize: bold ? 17 : 14))
      ]));
}
