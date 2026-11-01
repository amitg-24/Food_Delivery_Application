import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class FoodDetailsScreen extends StatelessWidget {
  const FoodDetailsScreen({super.key, required this.food});
  final FoodItem food;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food details')),
      body: ListView(children: [
        SizedBox(
            height: 280,
            child: CachedNetworkImage(
                imageUrl: food.imageUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.fastfood, size: 80))),
        Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: Text(food.name,
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold))),
                const Icon(Icons.star, color: Colors.amber),
                Text(food.rating.toStringAsFixed(1))
              ]),
              const SizedBox(height: 12),
              Text('₹${food.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B35))),
              const SizedBox(height: 16),
              Text(food.description,
                  style: TextStyle(
                      fontSize: 16, height: 1.5, color: Colors.grey.shade700)),
              const SizedBox(height: 18),
              Row(children: [
                const Icon(Icons.access_time, size: 18),
                const SizedBox(width: 6),
                Text('Estimated delivery: 25–35 min',
                    style: TextStyle(color: Colors.grey.shade700))
              ]),
              const SizedBox(height: 28),
              SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      context.read<CartProvider>().add(food);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart')));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CartScreen()));
                    },
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: const Text('Add to cart'),
                  )),
            ])),
      ]),
    );
  }
}
