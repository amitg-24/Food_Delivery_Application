import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrderProvider extends ChangeNotifier {
  final List<FoodOrder> _orders = [];
  List<FoodOrder> get orders => List.unmodifiable(_orders);

  void placeOrder(
      {required String customerName,
      required String address,
      required List<CartItem> items,
      required double total}) {
    final copy = items
        .map((item) => CartItem(food: item.food, quantity: item.quantity))
        .toList();
    _orders.insert(
        0,
        FoodOrder(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          customerName: customerName,
          address: address,
          items: copy,
          total: total,
          createdAt: DateTime.now(),
        ));
    notifyListeners();
  }
}
