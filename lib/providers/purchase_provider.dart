import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';

class PurchaseProvider with ChangeNotifier {
  Future<void> savePurchase(int userId, double total, List<Product> items) async {
    final dbHelper = DatabaseHelper.instance;

    // 1. Save Purchase
    final purchase = Purchase(
      userId: userId,
      total: total,
      date: DateTime.now().toIso8601String(),
    );
    final purchaseId = await dbHelper.createPurchase(purchase.toMap());

    // 2. Save Purchase Items
    for (var item in items) {
      final purchaseItem = PurchaseItem(
        purchaseId: purchaseId,
        productName: item.name,
        price: item.price,
      );
      await dbHelper.createPurchaseItem(purchaseItem.toMap());
    }
    
    notifyListeners();
  }
}
