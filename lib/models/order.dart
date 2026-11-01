import 'cart_item.dart';

class FoodOrder {
  FoodOrder(
      {required this.id,
      required this.customerName,
      required this.address,
      required this.items,
      required this.total,
      required this.createdAt,
      this.status = 'Confirmed'});
  final String id;
  final String customerName;
  final String address;
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;
  final String status;
}
