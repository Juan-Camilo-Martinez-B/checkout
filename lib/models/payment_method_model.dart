class PaymentMethod {
  final int? id;
  final int userId;
  final String cardType;
  final String cardHolder;
  final String last4;

  PaymentMethod({
    this.id,
    required this.userId,
    required this.cardType,
    required this.cardHolder,
    required this.last4,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'card_type': cardType,
      'card_holder': cardHolder,
      'last4': last4,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'],
      userId: map['user_id'],
      cardType: map['card_type'],
      cardHolder: map['card_holder'],
      last4: map['last4'],
    );
  }
}
