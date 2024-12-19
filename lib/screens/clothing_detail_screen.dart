import 'package:clothing_store/models/clothing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClothingDetailScreen extends StatelessWidget {
  final Clothing clothing;

  const ClothingDetailScreen({super.key, required this.clothing});

  Future<void> _addToCart(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('cart').add({
        ...clothing.toMap(),
        'userId': 'current_user_id', // You'll need to implement user management
      });
      Navigator.pop(context);
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(clothing.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(clothing.imageUrl),
            Text('Category: ${clothing.category}'),
            Text('Size: ${clothing.size}'),
            Text('Brand: ${clothing.brand}'),
            Text('Price: €${clothing.price}'),
            ElevatedButton(
              onPressed: () => _addToCart(context),
              child: const Text('Ajouter au panier'),
            ),
          ],
        ),
      ),
    );
  }
}