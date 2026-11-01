class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
    this.isVeg = true,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final double rating;
  final String imageUrl;
  final bool isVeg;
}
