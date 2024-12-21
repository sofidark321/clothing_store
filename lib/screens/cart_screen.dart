import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/clothing.dart';
import '../widgets/cart/cart_item_tile.dart';
import '../widgets/cart/cart_total_bar.dart';
import '../widgets/cart/empty_cart.dart';
import '../widgets/loading_indicator.dart';
import '../theme/app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue.withOpacity(0.1),
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .where('userId', isEqualTo: 'current_user_id')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingIndicator();
          }

          final items = snapshot.data!.docs;
          
          if (items.isEmpty) {
            return const EmptyCart();
          }

          final total = items.fold<double>(
            0,
            (sum, item) => sum + (item.data() as Map<String, dynamic>)['price'],
          );

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final clothing = Clothing.fromMap(
                      item.data() as Map<String, dynamic>,
                    );

                    return CartItemTile(
                      clothing: clothing,
                      onDelete: () => item.reference.delete(),
                    );
                  },
                ),
              ),
              CartTotalBar(total: total),
            ],
          );
        },
      ),
    );
  }
}