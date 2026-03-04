class Purchase {
  final int? id;
  final int userId;
  final double total;
  final String date;

  Purchase({
    this.id,
    required this.userId,
    required this.total,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'total': total,
      'date': date,
    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'],
      userId: map['user_id'],
      total: map['total'],
      date: map['date'],
    );
  }
}

class PurchaseItem {
  final int? id;
  final int purchaseId;
  final String productName;
  final double price;

  PurchaseItem({
    this.id,
    required this.purchaseId,
    required this.productName,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'purchase_id': purchaseId,
      'product_name': productName,
      'price': price,
    };
  }
}
