import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:clothing_store/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
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
  Interpreter? _interpreter;
  String _classificationResult = "";

  final List<String> _categories = [
    "Pantalon",
    "Shirt",
    "Chaussure",
    "Shorts",
    "Espadrille",
    "T-shirt"
  ];

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('./assets/clothing-classifier.tflite');
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _classificationResult = "Processing...";
      });
      await _classifyImage(File(image.path));
    }
  }

  Future<String> _imageToBase64() async {
    if (_imageFile == null) return '';

    try {
      List<int> imageBytes = await _imageFile!.readAsBytes();
      return base64Encode(imageBytes);
    } catch (e) {
      throw Exception('Failed to convert image');
    }
  }

  Future<void> _classifyImage(File imageFile) async {
    if (_interpreter == null) {
      setState(() {
        _classificationResult = "Model not loaded";
      });
      return;
    }

    try {
      final img.Image? inputImage =
          img.decodeImage(imageFile.readAsBytesSync());
      if (inputImage == null) {
        setState(() {
          _classificationResult = "Invalid image format";
        });
        return;
      }

      final resizedImage = img.copyResize(inputImage, width: 32, height: 32);

      final input = Float32List(32 * 32 * 3);
      for (int y = 0; y < 32; y++) {
        for (int x = 0; x < 32; x++) {
          final pixel = resizedImage.getPixel(x, y);
          final index = (y * 32 + x) * 3;
          input[index] = pixel.r.toDouble();
          input[index + 1] = pixel.g.toDouble();
          input[index + 2] = pixel.b.toDouble();
        }
      }

      final output =
          Float32List(_categories.length).reshape([1, _categories.length]);
      _interpreter!.run(input.reshape([1, 32, 32, 3]), output);

      final predictedIndex = output[0].indexWhere(
        (score) =>
            score == output[0].reduce((double a, double b) => a > b ? a : b),
      );

      setState(() {
        _category = _categories[predictedIndex];
        _classificationResult = "Classified as: ${_categories[predictedIndex]}";
      });
    } catch (e) {
      setState(() {
        _classificationResult = "Error during classification: $e";
      });
    }
  }

  Future<void> _saveClothing() async {
    if (!_formKey.currentState!.validate() || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final imageBase64 = await _imageToBase64();

      final clothing = Clothing(
        id: DateTime.now().toString(),
        title: _titleController.text,
        imageUrl: imageBase64,
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
        const SnackBar(content: Text('Clothing added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding clothing: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _interpreter?.close();
    _titleController.dispose();
    _sizeController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Clothing',
         style: TextStyle(  
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF023047),
                    ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFF219EBC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_classificationResult.isNotEmpty)
                  Text(
                    _classificationResult,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF023047),
                    ),
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _category = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _sizeController,
                  decoration: const InputDecoration(
                    labelText: 'Size',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a size';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _brandController,
                  decoration: const InputDecoration(
                    labelText: 'Brand',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a brand';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveClothing,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: const Color(0xFFFB8500),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Add Clothing',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
