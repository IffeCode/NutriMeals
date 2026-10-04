import 'package:flutter/material.dart';

import 'recipe_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> ingredients = [
    'Chicken',
    'Rice',
    'Onion',
    'Tomato',
    'Egg',
    'Potato',
    'Garlic',
    'Pasta',
  ];

  final Set<String> selectedIngredients = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriMeals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vad finns i kylen?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Välj ingredienser du har hemma.',
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: ingredients.map((ingredient) {
                  return CheckboxListTile(
                    title: Text(ingredient),
                    value: selectedIngredients.contains(ingredient),
                    onChanged: (selected) {
                      setState(() {
                        if (selected == true) {
                          selectedIngredients.add(ingredient);
                        } else {
                          selectedIngredients.remove(ingredient);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedIngredients.isEmpty
                    ? null
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipePage(
                        selectedIngredients:
                        selectedIngredients.toList(),
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Visa recept',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}