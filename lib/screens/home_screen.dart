import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_data.dart';
import '../providers/cart_provider.dart';
import '../widgets/food_card.dart';
import 'cart_screen.dart';
import 'food_details_screen.dart';
import 'orders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _category = 'All';
  String _query = '';
  final _categories = const [
    'All',
    'Pizza',
    'Burgers',
    'Biryani',
    'Wraps',
    'Sides',
    'Desserts'
  ];

  @override
  Widget build(BuildContext context) {
    final foods = foodItems.where((food) {
      final matchesCategory = _category == 'All' || food.category == _category;
      final matchesQuery = '${food.name} ${food.category}'
          .toLowerCase()
          .contains(_query.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Foodie', style: TextStyle(fontWeight: FontWeight.w800)),
              Text('Delivering happiness 🍽️',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal))
            ]),
        actions: [
          IconButton(
              tooltip: 'Orders',
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const OrdersScreen())),
              icon: const Icon(Icons.receipt_long_outlined)),
          Consumer<CartProvider>(
              builder: (_, cart, __) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Badge(
                        label: Text('${cart.itemCount}'),
                        isLabelVisible: cart.itemCount > 0,
                        child: IconButton(
                            tooltip: 'Cart',
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const CartScreen())),
                            icon: const Icon(Icons.shopping_bag_outlined))),
                  )),
        ],
      ),
      body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFFFF875F), Color(0xFFFF6B35)]),
                  borderRadius: BorderRadius.circular(22)),
              child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('GOOD FOOD, GOOD MOOD',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Your cravings,\njust a tap away.',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800)),
                    SizedBox(height: 8),
                    Text('Fresh favourites delivered to your door.',
                        style: TextStyle(color: Colors.white)),
                  ]),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                  hintText: 'Search pizza, burgers, biryani...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none)),
            ),
            const SizedBox(height: 22),
            const Text('Explore categories',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
                height: 42,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _categories
                        .map((category) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                  label: Text(category),
                                  selected: _category == category,
                                  onSelected: (_) =>
                                      setState(() => _category = category)),
                            ))
                        .toList())),
            const SizedBox(height: 18),
            Row(children: [
              const Expanded(
                  child: Text('Popular near you',
                      style: TextStyle(
                          fontSize: 19, fontWeight: FontWeight.bold))),
              Text('${foods.length} items',
                  style: TextStyle(color: Colors.grey.shade600))
            ]),
            const SizedBox(height: 10),
            if (foods.isEmpty)
              const Padding(
                  padding: EdgeInsets.all(30),
                  child:
                      Center(child: Text('No food found. Try another search.')))
            else
              ...foods.map((food) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: FoodCard(
                    food: food,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => FoodDetailsScreen(food: food))),
                    onAdd: () {
                      context.read<CartProvider>().add(food);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${food.name} added to cart'),
                          duration: const Duration(seconds: 1)));
                    },
                  ))),
          ]),
    );
  }
}
