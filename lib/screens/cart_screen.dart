import 'package:clothing_store/models/clothing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .where('userId', isEqualTo: 'current_user_id')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

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

                    return ListTile(
                      leading: Image.network(clothing.imageUrl),
                      title: Text(clothing.title),
                      subtitle: Text('Size: ${clothing.size}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('€${clothing.price}'),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => item.reference.delete(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: €${total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}