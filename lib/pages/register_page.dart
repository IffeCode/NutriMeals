import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'profile_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final DatabaseReference _database =
  FirebaseDatabase.instance.ref();

  final TextEditingController _usernameController =
  TextEditingController();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _firstNameController =
  TextEditingController();

  final TextEditingController _lastNameController =
  TextEditingController();

  final TextEditingController _dateOfBirthController =
  TextEditingController();

  final TextEditingController _heightController =
  TextEditingController();

  final TextEditingController _weightController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final TextEditingController _confirmPasswordController =
  TextEditingController();

  String? selectedGender;

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  Future<void> selectDateOfBirth() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _dateOfBirthController.text =
        '${selectedDate.year}-'
            '${selectedDate.month.toString().padLeft(2, '0')}-'
            '${selectedDate.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> register() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final dateOfBirth = _dateOfBirthController.text.trim();
    final height = _heightController.text.trim();
    final weight = _weightController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword =
    _confirmPasswordController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        dateOfBirth.isEmpty ||
        height.isEmpty ||
        weight.isEmpty ||
        selectedGender == null ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage('Please fill in all fields.');
      return;
    }

    if (password != confirmPassword) {
      showMessage('Passwords do not match.');
      return;
    }

    if (password.length < 8) {
      showMessage(
        'Password must contain at least 8 characters.',
      );
      return;
    }

    final heightValue = double.tryParse(height);
    final weightValue = double.tryParse(weight);

    if (heightValue == null || weightValue == null) {
      showMessage('Height and weight must be numbers.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final credential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception('Could not create user.');
      }

      await _database
          .child('users')
          .child(user.uid)
          .set({
        'userId': user.uid,
        'username': username,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'gender': selectedGender,
        'dateOfBirth': dateOfBirth,
        'height': heightValue,
        'weight': weightValue,
      });

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ),
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message =
          'An account with this email already exists.';
          break;

        case 'invalid-email':
          message = 'Invalid email address.';
          break;

        case 'weak-password':
          message = 'The password is too weak.';
          break;

        default:
          message = 'Could not create the account.';
      }

      showMessage(message);
    } catch (e) {
      showMessage(
        'Something went wrong while creating the account.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(
                Icons.person_add,
                size: 70,
                color: Colors.green,
              ),

              const SizedBox(height: 20),

              const Text(
                'Create your NutriMeals account',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: Icon(Icons.people),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Male',
                    child: Text('Male'),
                  ),
                  DropdownMenuItem(
                    value: 'Female',
                    child: Text('Female'),
                  ),
                  DropdownMenuItem(
                    value: 'Other',
                    child: Text('Other'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _dateOfBirthController,
                readOnly: true,
                onTap: selectDateOfBirth,
                decoration: const InputDecoration(
                  labelText: 'Date of birth',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  prefixIcon: Icon(Icons.height),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  prefixIcon: Icon(Icons.monitor_weight),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _confirmPasswordController,
                obscureText: obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword =
                        !obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : register,
                  child: isLoading
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(),
                  )
                      : const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}