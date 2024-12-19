import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../models/clothing.dart';

class AddClothingScreen extends StatefulWidget {
  const AddClothingScreen({super.key});

  @override
  _AddClothingScreenState createState() => _AddClothingScreenState();
}

class _AddClothingScreenState extends State<AddClothingScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  String? _category;
  final _titleController = TextEditingController();
  final _sizeController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;

  final List<String> _categories = ['Pantalon', 'Short', 'Haut', 'Robe', 'Jupe', 'Accessoire'];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,  // Limiter la taille de l'image
      maxHeight: 800,
      imageQuality: 85  // Compression
    );
    
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _category = _categories[0];
      });
    }
  }

  Future<String> _imageToBase64() async {
    if (_imageFile == null) return '';
    
    try {
      List<int> imageBytes = await _imageFile!.readAsBytes();
      return base64Encode(imageBytes);
    } catch (e) {
      print('Erreur de conversion en base64: $e');
      throw Exception('Échec de la conversion de l\'image');
    }
  }

  Future<void> _saveClothing() async {
    if (!_formKey.currentState!.validate() || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final imageBase64 = await _imageToBase64();
      
      final clothing = Clothing(
        id: DateTime.now().toString(),
        title: _titleController.text,
        imageUrl: imageBase64,  // Stockage de l'image en base64
        size: _sizeController.text,
        price: double.parse(_priceController.text),
        category: _category ?? '',
        brand: _brandController.text,
      );

      await FirebaseFirestore.instance
          .collection('clothes')
          .doc(clothing.id)
          .set(clothing.toMap());

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vêtement ajouté avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un vêtement'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Zone de l'image
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : const Icon(Icons.add_photo_alternate, size: 50),
              ),
            ),
            const SizedBox(height: 16),
            
            // Titre
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
              validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
            ),
            
            // Catégorie (non éditable)
            TextFormField(
              initialValue: _category,
              enabled: false,
              decoration: const InputDecoration(labelText: 'Catégorie'),
            ),
            
            // Taille
            TextFormField(
              controller: _sizeController,
              decoration: const InputDecoration(labelText: 'Taille'),
              validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
            ),
            
            // Marque
            TextFormField(
              controller: _brandController,
              decoration: const InputDecoration(labelText: 'Marque'),
              validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
            ),
            
            // Prix
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Prix',
                suffixText: '€',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Champ requis';
                if (double.tryParse(value!) == null) return 'Prix invalide';
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _saveClothing,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Valider'),
            ),
          ],
        ),
      ),
    );
  }
}
