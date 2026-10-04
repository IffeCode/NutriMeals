import 'package:flutter/material.dart';

import 'recipe_details_page.dart';
import '../model/recipe_model.dart';
import '../services/api_service.dart';

class RecipePage extends StatefulWidget {
  final List<String>? selectedIngredients;

  const RecipePage({
    super.key,
    this.selectedIngredients,
  });

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<RecipeModel> recipes = [];
  bool isLoading = false;
  String? error;

  Future<void> searchRecipes() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final results = await _apiService.searchRecipes(query);

      setState(() {
        recipes = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> loadIngredientRecipes() async {
    final ingredients = widget.selectedIngredients;

    if (ingredients == null || ingredients.isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final results =
      await _apiService.findRecipesByIngredients(ingredients);

      setState(() {
        recipes = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> openRecipe(RecipeModel recipe) async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final fullRecipe = await _apiService.getRecipe(recipe.id);

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetailsPage(
            recipe: fullRecipe,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.selectedIngredients != null &&
        widget.selectedIngredients!.isNotEmpty) {
      loadIngredientRecipes();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriMeals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => searchRecipes(),
              decoration: InputDecoration(
                hintText: 'Sök efter recept...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: searchRecipes,
                ),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            if (isLoading)
              const CircularProgressIndicator(),

            if (error != null)
              Text(
                error!,
                style: const TextStyle(color: Colors.red),
              ),

            if (!isLoading && error == null)
              Expanded(
                child: ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: Image.network(
                          recipe.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        title: Text(recipe.title),
                        subtitle: Text(
                          recipe.readyInMinutes > 0
                              ? '${recipe.readyInMinutes} minuter'
                              : 'Visa recept',
                        ),
                        onTap: () => openRecipe(recipe),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}