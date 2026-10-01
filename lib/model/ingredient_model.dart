class IngredientModel {
  final int id;
  final String name;
  final double amount;
  final String unit;
  final String image;

  IngredientModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
    required this.image,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      image: json['image'] ?? '',
    );
  }
}