import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'My Profile',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Email',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 4),

            Text(
              user?.email ?? 'No email found',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                child: const Text('Continue to NutriMeals'),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Edit Profile will be added here.
                },
                child: const Text('Edit Profile'),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => logout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Log out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}