import 'package:clothing_store/models/user.dart';
import 'package:clothing_store/screens/AddClothingScreen.dart';
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
        DateTime? birthDate;
        if (data['birthday'] != null) {
          if (data['birthday'] is Timestamp) {
            birthDate = (data['birthday'] as Timestamp).toDate();
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
          'birthday': user.birthday != null ? Timestamp.fromDate(user.birthday!) : null,
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

  void _navigateToAddClothing() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddClothingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Profile',
        style: TextStyle(  
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 250, 250, 250),
                    ),
        ),
        backgroundColor: const Color(0xFF023047),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app,
            color: Color(0xFFcc3535),),
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddClothing,
        backgroundColor: const Color(0xFFFB8500),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'User Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF023047),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              initialValue: user.login,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: const Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              initialValue: user.password,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (value) => user.password = value,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              initialValue: user.birthday != null
                                  ? formatBirthday(user.birthday)
                                  : '',
                              decoration: InputDecoration(
                                labelText: 'Birthday',
                                prefixIcon: const Icon(Icons.calendar_today),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (value) {
                                try {
                                  user.birthday = DateFormat('dd/MM/yyyy').parse(value);
                                } catch (e) {
                                  user.birthday = null;
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              initialValue: user.address,
                              decoration: InputDecoration(
                                labelText: 'Address',
                                prefixIcon: const Icon(Icons.home),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (value) => user.address = value,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              initialValue: user.postalCode,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Postal Code',
                                prefixIcon: const Icon(Icons.code),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (value) => user.postalCode = value,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              initialValue: user.city,
                              decoration: InputDecoration(
                                labelText: 'City',
                                prefixIcon: const Icon(Icons.location_city),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (value) => user.city = value,
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _saveProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFB8500),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Save Profile'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
