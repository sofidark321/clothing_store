import 'dart:convert';
import 'package:clothing_store/base64_image.dart';
import 'package:clothing_store/models/clothing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panier')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .where('userId', isEqualTo: 'current_user_id')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs;
          double total = items.fold(
            0,
            (sum, item) => sum + (item.data() as Map<String, dynamic>)['price'],
          );

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final clothing = Clothing.fromMap(
                      item.data() as Map<String, dynamic>,
                    );

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: SizedBox(
                          width: 60,
                          height: 60,
                          child: Base64Image(
                            base64String: clothing.imageUrl,
                            width: 60,
                            height: 60,
                          ),
                        ),
                        title: Text(clothing.title),
                        subtitle: Text('Taille: ${clothing.size}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('€${clothing.price.toStringAsFixed(2)}'),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => item.reference.delete(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: €${total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}