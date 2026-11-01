import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/food_item.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({super.key, required this.food, required this.onTap, required this.onAdd});
  final FoodItem food;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AspectRatio(
            aspectRatio: 1.55,
            child: CachedNetworkImage(
              imageUrl: food.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) => const Center(child: Icon(Icons.fastfood, size: 48)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 9, height: 9, decoration: BoxDecoration(shape: BoxShape.circle, color: food.isVeg ? Colors.green : Colors.red)),
                const SizedBox(width: 6),
                Expanded(child: Text(food.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15))),
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(food.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12)),
              ]),
              const SizedBox(height: 6),
              Text(food.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: Text('₹${food.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17))),
                FilledButton.tonal(onPressed: onAdd, child: const Text('ADD')),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
