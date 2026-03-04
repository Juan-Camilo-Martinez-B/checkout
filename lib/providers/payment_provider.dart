import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/payment_method_model.dart';

class PaymentProvider with ChangeNotifier {
  List<PaymentMethod> _savedMethods = [];

  List<PaymentMethod> get savedMethods => _savedMethods;

  Future<void> fetchMethods(int userId) async {
    final dbHelper = DatabaseHelper.instance;
    final data = await dbHelper.getPaymentMethods(userId);
    _savedMethods = data.map((item) => PaymentMethod.fromMap(item)).toList();
    notifyListeners();
  }

  Future<void> addMethod(PaymentMethod method) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.createPaymentMethod(method.toMap());
    await fetchMethods(method.userId);
  }
}
