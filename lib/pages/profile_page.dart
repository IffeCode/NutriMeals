import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'edit_profile_page.dart';
import 'home_page.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database =
  FirebaseDatabase.instance.ref();

  Map<String, dynamic>? userData;

  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      setState(() {
        error = 'No user is currently logged in.';
        isLoading = false;
      });
      return;
    }

    try {
      final snapshot = await _database
          .child('users')
          .child(user.uid)
          .get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(
          snapshot.value as Map,
        );

        setState(() {
          userData = data;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'No profile information was found.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Could not load your profile.';
        isLoading = false;
      });
    }
  }

  Future<void> logout() async {
    await _auth.signOut();

    if (!mounted) return;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : error != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            error!,
            textAlign: TextAlign.center,
          ),
        ),
      )
          : SingleChildScrollView(
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

            const SizedBox(height: 20),

            Center(
              child: Text(
                userData?['username'] ?? 'User',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            profileItem(
              'Username',
              userData?['username'],
              Icons.person,
            ),

            profileItem(
              'Email',
              userData?['email'],
              Icons.email,
            ),

            profileItem(
              'First name',
              userData?['firstName'],
              Icons.person_outline,
            ),

            profileItem(
              'Last name',
              userData?['lastName'],
              Icons.person_outline,
            ),

            profileItem(
              'Gender',
              userData?['gender'],
              Icons.people,
            ),

            profileItem(
              'Date of birth',
              userData?['dateOfBirth'],
              Icons.calendar_today,
            ),

            profileItem(
              'Height',
              '${userData?['height'] ?? '-'} cm',
              Icons.height,
            ),

            profileItem(
              'Weight',
              '${userData?['weight'] ?? '-'} kg',
              Icons.monitor_weight,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const HomePage(),
                    ),
                  );
                },
                child: const Text(
                  'Continue to NutriMeals',
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        userData: userData!,
                      ),
                    ),
                  );

                  if (updated == true && mounted) {
                    await loadUserProfile();
                  }
                },
                child: const Text(
                  'Edit Profile',
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: logout,
                icon: const Icon(Icons.logout),
                label: const Text('Log out'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileItem(
      String label,
      dynamic value,
      IconData icon,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Card(
        child: ListTile(
          leading: Icon(icon),
          title: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            value?.toString() ?? '-',
          ),
        ),
      ),
    );
  }
}