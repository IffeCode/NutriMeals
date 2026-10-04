import 'package:flutter/material.dart';

import '../model/recipe_model.dart';

class RecipeDetailsPage extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeDetailsPage({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              recipe.image,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 16),

            Text(
              recipe.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 8),

            Text(
              'Tid: ${recipe.readyInMinutes} minuter',
            ),

            Text(
              'Portioner: ${recipe.servings}',
            ),

            const SizedBox(height: 24),

            const Text(
              'Ingredienser',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            ...recipe.ingredients.map(
                  (ingredient) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  '• ${ingredient.name} – '
                      '${ingredient.amount} ${ingredient.unit}',
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Instruktioner',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(recipe.instructions),
          ],
        ),
      ),
    );
  }
}