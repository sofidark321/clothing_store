class Clothing {
  final String id;
  final String title;
  final String imageUrl;
  final String size;
  final double price;
  final String category;
  final String brand;

  Clothing({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.size,
    required this.price,
    required this.category,
    required this.brand,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'size': size,
      'price': price,
      'category': category,
      'brand': brand,
    };
  }

  factory Clothing.fromMap(Map<String, dynamic> map) {
    return Clothing(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      size: map['size'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      category: map['category'] ?? '',
      brand: map['brand'] ?? '',
    );
  }
}
