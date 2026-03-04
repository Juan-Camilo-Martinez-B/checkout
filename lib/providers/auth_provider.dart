import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<bool> login(String name, String password) async {
    final dbHelper = DatabaseHelper.instance;
    final userData = await dbHelper.getUser(name, password);

    if (userData != null) {
      _currentUser = User.fromMap(userData);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String password) async {
    final dbHelper = DatabaseHelper.instance;
    try {
      // Check if user exists (optional, but good practice)
      // For simplicity, we just create a new one as names might not be unique in this simple schema
      // In a real app, we should check for duplicates.
      
      final id = await dbHelper.createUser({
        'name': name,
        'password': password,
      });
      
      // Auto login after register? No, requirements say redirect to Login.
      return id > 0;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
