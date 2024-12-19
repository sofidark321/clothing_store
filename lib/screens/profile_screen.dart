import 'package:clothing_store/models/user.dart';
import 'package:clothing_store/screens/login_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late UserModel user;

  @override
  void initState() {
    super.initState();
    // Load user data
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Implement user data loading from Firestore
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      // Save to Firestore
    }
  }

  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              initialValue: user.login,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Login'),
            ),
            TextFormField(
              initialValue: user.password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            TextFormField(
              initialValue: user.address,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              initialValue: user.postalCode,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Postal Code'),
            ),
            TextFormField(
              initialValue: user.city,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Valider'),
            ),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}