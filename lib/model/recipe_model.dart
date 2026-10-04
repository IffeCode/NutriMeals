import 'ingredient_model.dart';
import 'nutrition_model.dart';

class RecipeModel {
  final int id;
  final String title;
  final String image;
  final int readyInMinutes;
  final int servings;
  final List<IngredientModel> ingredients;
  final String instructions;
  final NutritionModel? nutrition;

  RecipeModel({
    required this.id,
    required this.title,
    required this.image,
    required this.readyInMinutes,
    required this.servings,
    required this.ingredients,
    required this.instructions,
    this.nutrition,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    final ingredientsJson = json['extendedIngredients'] as List? ?? [];

    final instructionsList =
        json['analyzedInstructions'] as List? ?? [];

    final steps = <String>[];

    for (final instruction in instructionsList) {
      final stepList = instruction['steps'] as List? ?? [];

      for (final step in stepList) {
        final text = step['step'] as String?;
        if (text != null && text.isNotEmpty) {
          steps.add(text);
        }
      }
    }

    final nutritionJson = json['nutrition']?['nutrients'] as List?;

    return RecipeModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      readyInMinutes: json['readyInMinutes'] ?? 0,
      servings: json['servings'] ?? 0,
      ingredients: ingredientsJson
          .where((item) {
        if (item is! Map<String, dynamic>) {
          return false;
        }

        final name = item['name'];

        if (name is! String || name.isEmpty) {
          return false;
        }

        final lowerName = name.toLowerCase();

        final invalidPhrases = [
          'in a soup pot',
          'add ',
          'stir ',
          'put-in ',
          'if rice',
          'sprinkle ',
        ];

        return !invalidPhrases.any(
              (phrase) => lowerName.startsWith(phrase),
        );
      })
          .map((item) => IngredientModel.fromJson(item))
          .toList(),
      instructions: steps.join('\n\n'),
      nutrition: nutritionJson != null
          ? NutritionModel.fromNutrients(nutritionJson)
          : null,
    );
  }
}