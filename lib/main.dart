import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final apiService = ApiService();

  try {
    final recipe = await apiService.getRecipe(637942);

    print('Recipe: ${recipe['title']}');
    print('Image: ${recipe['image']}');
  } catch (e) {
    print('API ERROR: $e');
  }

  runApp(const MaterialApp(
      home: Scaffold(
          body: Center(
            child: Text('API test'),);
}