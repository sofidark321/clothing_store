import 'package:clothing_store/models/clothing.dart';
import 'package:clothing_store/screens/clothing_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClothingListScreen extends StatelessWidget {
  const ClothingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('clothes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final clothing = Clothing.fromMap(doc.data() as Map<String, dynamic>);

              return ListTile(
                leading: Image.network(clothing.imageUrl),
                title: Text(clothing.title),
                subtitle: Text('Size: ${clothing.size}'),
                trailing: Text('€${clothing.price}'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClothingDetailScreen(clothing: clothing),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}