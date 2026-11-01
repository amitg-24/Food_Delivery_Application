import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/food_item.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  Map<String, CartItem> get items => Map.unmodifiable(_items);
  int get itemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.values.fold(0, (sum, item) => sum + item.total);
  double get deliveryFee => _items.isEmpty || subtotal >= 499 ? 0 : 35;
  double get tax => subtotal * 0.05;
  double get total => subtotal + deliveryFee + tax;

  void add(FoodItem food) {
    if (_items.containsKey(food.id)) {
      _items[food.id]!.quantity++;
    } else {
      _items[food.id] = CartItem(food: food);
    }
    notifyListeners();
  }

  void decrement(String id) {
    final item = _items[id];
    if (item == null) return;
    if (item.quantity <= 1) {
      _items.remove(id);
    } else {
      item.quantity--;
    }
    notifyListeners();
  }

  void remove(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
