import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/clothing.dart';
import '../widgets/clothing_grid_item.dart';
import '../widgets/loading_indicator.dart';
import '../theme/app_theme.dart';

class ClothingListScreen extends StatefulWidget {
  const ClothingListScreen({super.key});

  @override
  _ClothingListScreenState createState() => _ClothingListScreenState();
}

class _ClothingListScreenState extends State<ClothingListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  double? _minPrice;
  double? _maxPrice;

  Stream<QuerySnapshot> getClothingStream() {
    Query query = FirebaseFirestore.instance.collection('clothes');

    // Apply search filters
    if (_searchQuery.isNotEmpty) {
      query = query.where('keywords', arrayContains: _searchQuery.toLowerCase());
    }

    // Apply category filter
    if (_selectedCategory != null) {
      query = query.where('category', isEqualTo: _selectedCategory);
    }

    // Apply price range filter
    if (_minPrice != null && _maxPrice != null) {
      query = query.where('price', isGreaterThanOrEqualTo: _minPrice);
      query = query.where('price', isLessThanOrEqualTo: _maxPrice);
    }

    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shop',
          style: TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
         
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.darkBlue),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getClothingStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingIndicator();
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No items found.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final clothing = Clothing.fromMap(doc.data() as Map<String, dynamic>);
              return ClothingGridItem(clothing: clothing);
            },
          );
        },
      ),
    );
  }


  void _showFilterDialog() {

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: [
                const DropdownMenuItem(value: null, child: Text('All Categories')),
                const DropdownMenuItem(value: 'Chaussure', child: Text('chaussure')),
                const DropdownMenuItem(value: 'Shirt', child: Text('Shirt')),
                const DropdownMenuItem(value: 'Pantalon', child: Text('Pantalon')),
                const DropdownMenuItem(value: 'Espadrille', child: Text('Espadrille')),
                const DropdownMenuItem(value: 'T-shirt', child: Text('T-shirt')),
              
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Select Category',
                border: OutlineInputBorder(),
              ),
            ),
           
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {

              });
              Navigator.of(context).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
