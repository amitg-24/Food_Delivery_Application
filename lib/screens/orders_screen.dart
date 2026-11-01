import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('My orders')),
      body: Consumer<OrderProvider>(builder: (context, provider, _) {
        if (provider.orders.isEmpty)
          return const Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.receipt_long_outlined, size: 68, color: Colors.grey),
            SizedBox(height: 12),
            Text('No orders yet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Your placed demo orders will appear here.')
          ]
          )
          );
        return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.orders.length,
            itemBuilder: (context, index) {
              final order = provider.orders[index];
              return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Expanded(
                                  child: Text(
                                      'Order #${order.id.substring(order.id.length - 6)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Chip(
                                  label: Text(order.status),
                                  avatar:
                                      const Icon(Icons.check_circle, size: 16))
                            ]),
                            Text(
                                order.createdAt
                                    .toLocal()
                                    .toString()
                                    .substring(0, 16),
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12)),
                            const Divider(height: 22),
                            ...order.items.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                    '${item.quantity} × ${item.food.name}'))),
                            const SizedBox(height: 8),
                            Text('Deliver to: ${order.address}'),
                            const SizedBox(height: 8),
                            Text('Total: ₹${order.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ])));
            });
      }));
}
