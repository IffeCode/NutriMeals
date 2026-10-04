import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
final Map<String, dynamic> userData;

const EditProfilePage({
super.key,
required this.userData,
});
@override
State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database =
  FirebaseDatabase.instance.ref();

  late final TextEditingController _usernameController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _dateOfBirthController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;

  String? selectedGender;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController(
      text: widget.userData['username']?.toString() ?? '',
    );

    _firstNameController = TextEditingController(
      text: widget.userData['firstName']?.toString() ?? '',
    );

    _lastNameController = TextEditingController(
      text: widget.userData['lastName']?.toString() ?? '',
    );

    _dateOfBirthController = TextEditingController(
      text: widget.userData['dateOfBirth']?.toString() ?? '',
    );

    _heightController = TextEditingController(
      text: widget.userData['height']?.toString() ?? '',
    );

    _weightController = TextEditingController(
      text: widget.userData['weight']?.toString() ?? '',
    );

    selectedGender = widget.userData['gender']?.toString();
  }

  Future<void> selectDateOfBirth() async {
    DateTime initialDate = DateTime(2000);

    final currentDate = _dateOfBirthController.text;

    if (currentDate.isNotEmpty) {
      try {
        initialDate = DateTime.parse(currentDate);
      } catch (_) {
        initialDate = DateTime(2000);
      }
    }

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
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

  Future<void> saveProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      showMessage('No user is currently logged in.');
      return;
    }

    final username = _usernameController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final dateOfBirth = _dateOfBirthController.text.trim();
    final height = _heightController.text.trim();
    final weight = _weightController.text.trim();

    if (username.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        dateOfBirth.isEmpty ||
        height.isEmpty ||
        weight.isEmpty ||
        selectedGender == null) {
      showMessage('Please fill in all fields.');
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
      await _database
          .child('users')
          .child(user.uid)
          .update({
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'gender': selectedGender,
        'dateOfBirth': dateOfBirth,
        'height': heightValue,
        'weight': weightValue,
      });

      if (!mounted) return;

      showMessage('Profile updated successfully.');

      Navigator.pop(context, true);
    } catch (e) {
      showMessage('Could not update your profile.');
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    _heightController.dispose();
    _weightController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(
                Icons.edit,
                size: 70,
                color: Colors.green,
              ),

              const SizedBox(height: 20),

              const Text(
                'Edit your profile',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
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

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : saveProfile,
                  child: isLoading
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(),
                  )
                      : const Text(
                    'Save Changes',
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