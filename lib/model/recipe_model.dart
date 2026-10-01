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
}