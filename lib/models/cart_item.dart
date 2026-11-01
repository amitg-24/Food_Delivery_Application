import 'food_item.dart';

class CartItem {
  CartItem({required this.food, this.quantity = 1});
  final FoodItem food;
  int quantity;
  double get total => food.price * quantity;
}
