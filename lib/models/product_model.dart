class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  // Helper method to generate random products
  static List<Product> generateRandomProducts() {
    return [
      Product(id: 1, name: 'Nike Air Max', price: 120.0),
      Product(id: 2, name: 'Adidas Ultraboost', price: 180.0),
      Product(id: 3, name: 'Puma RS-X', price: 110.0),
      Product(id: 4, name: 'Reebok Classic', price: 85.0),
      Product(id: 5, name: 'New Balance 574', price: 95.0),
      Product(id: 6, name: 'Vans Old Skool', price: 65.0),
      Product(id: 7, name: 'Converse All Star', price: 60.0),
      Product(id: 8, name: 'Under Armour Hovr', price: 130.0),
      Product(id: 9, name: 'Asics Gel-Kayano', price: 160.0),
      Product(id: 10, name: 'Fila Disruptor', price: 70.0),
    ];
  }
}
