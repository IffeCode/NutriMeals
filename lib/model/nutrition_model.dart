class NutritionModel {

  final double calories;
  final double protein;
  final double fat;
  final double carbohydrates;
  final double fiber;
  final double sugar;
  final double sodium;

  NutritionModel({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbohydrates,
    required this.fiber,
    required this.sugar,
    required this.sodium,
});

factory NutritionModel.fromNutrients(List<dynamic> nutrients) {
  double getValue(String name) {
    final nutrient = nutrients.firstWhere(
          (item) => item['name'] == name,
      orElse: () => {'amount': 0},
    );

    return (nutrient['amount'] ?? 0).toDouble();
  }

  return NutritionModel(
    calories: getValue('Calories'),
    protein: getValue('Protein'),
    fat: getValue('Fat'),
    carbohydrates: getValue('Carbohydrates'),
    fiber: getValue('Fiber'),
    sugar: getValue('Sugar'),
    sodium: getValue('Sodium'),
  );
}


}