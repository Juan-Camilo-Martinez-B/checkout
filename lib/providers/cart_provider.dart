import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  double get total => _items.fold(0, (sum, item) => sum + item.price);

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool contains(Product product) {
    return _items.contains(product);
  }
}
