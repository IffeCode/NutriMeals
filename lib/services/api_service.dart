import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_keys.dart';
import '../model/recipe_model.dart';

class ApiService {
  static const String _baseUrl = 'https://api.spoonacular.com';

  Future<List<RecipeModel>> searchRecipes(String query) async {
    final url = Uri.parse(
      '$_baseUrl/recipes/complexSearch'
          '?query=$query'
          '&number=10'
          '&addRecipeInformation=true'
          '&apiKey=${ApiKeys.spoonacular}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final results = data['results'] as List;

      return results
          .map((item) => RecipeModel.fromJson(item))
          .toList();
    }

    throw Exception(
      'Kunde inte söka recept. Statuskod: ${response.statusCode}',
    );
  }

  Future<List<RecipeModel>> findRecipesByIngredients(
      List<String> ingredients,
      ) async {
    final ingredientQuery = ingredients.join(',');

    final url = Uri.parse(
      '$_baseUrl/recipes/findByIngredients'
          '?ingredients=$ingredientQuery'
          '&number=10'
          '&ranking=1'
          '&apiKey=${ApiKeys.spoonacular}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;

      return data.map((item) {
        return RecipeModel(
          id: item['id'] ?? 0,
          title: item['title'] ?? '',
          image: item['image'] ?? '',
          readyInMinutes: 0,
          servings: 0,
          ingredients: [],
          instructions: '',
        );
      }).toList();
    }

    throw Exception(
      'Kunde inte hitta recept med ingredienser. '
          'Statuskod: ${response.statusCode}',
    );
  }

  Future<RecipeModel> getRecipe(int id) async {
    final url = Uri.parse(
      '$_baseUrl/recipes/$id/information'
          '?includeNutrition=true'
          '&apiKey=${ApiKeys.spoonacular}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return RecipeModel.fromJson(data);
    }

    throw Exception(
      'Kunde inte hämta recept. Statuskod: ${response.statusCode}',
    );
  }
}