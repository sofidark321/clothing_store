import 'package:clothing_store/models/user.dart';
import 'package:clothing_store/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  UserModel user = UserModel(
    login: '',
    password: '',
  );
  bool _isLoading = true;

  // Date formatter
  final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy');

  String formatBirthday(DateTime? date) {
    if (date == null) return '';
    return _dateFormatter.format(date);
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc('n17mXEVPe9NBOz6J5tYZ')
          .get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        // Convert Timestamp to DateTime
        DateTime? birthDate;
        if (data['birthday'] != null) {
          if (data['birthday'] is Timestamp) {
            birthDate = (data['birthday'] as Timestamp).toDate();
          } else if (data['birthday'] is String) {
            try {
              birthDate = DateFormat('dd/MM/yyyy').parse(data['birthday']);
            } catch (e) {
              print('Error parsing date: $e');
            }
          }
        }

        setState(() {
          user = UserModel(
            login: data['login'] ?? '',
            password: data['password'] ?? '',
            address: data['adresse'] ?? '',
            postalCode: data['postalCode'] ?? '',
            city: data['city'] ?? '',
            birthday: birthDate,
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final Map<String, dynamic> updateData = {
          'login': user.login,
          'password': user.password,
          'birthday':Timestamp.fromDate(user.birthday!),
          'adresse': user.address,
          'postalCode': user.postalCode,
          'city': user.city,
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc('n17mXEVPe9NBOz6J5tYZ')
            .update(updateData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
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
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
        ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              TextFormField(
                initialValue: user.login,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                initialValue: user.password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                onChanged: (value) => user.password = value,
              ),
              TextFormField(
                initialValue: formatBirthday(user.birthday),
                decoration: const InputDecoration(labelText: 'Birthday'),
                onChanged: (value) => user.birthday = DateFormat('dd/MM/yyyy').parse(value),
              ),
              TextFormField(
                initialValue: user.address,
                decoration: const InputDecoration(labelText: 'Address'),
                onChanged: (value) => user.address = value,
              ),
              TextFormField(
                initialValue: user.postalCode,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Postal Code'),
                onChanged: (value) => user.postalCode = value,
              ),
              TextFormField(
                initialValue: user.city,
                decoration: const InputDecoration(labelText: 'City'),
                onChanged: (value) => user.city = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  _saveProfile;
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      
    );
  }
}
