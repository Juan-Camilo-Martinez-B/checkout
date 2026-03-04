import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';
import 'login_screen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late List<Product> _products;

  @override
  void initState() {
    super.initState();
    _products = Product.generateRandomProducts();
  }

  void _logout() {
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout Simulator'),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: _logout,
          tooltip: 'Cerrar sesión',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Productos',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Consumer<CartProvider>(
                  builder: (context, cart, child) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '\$${cart.total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: _products.length,
              separatorBuilder: (ctx, i) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final product = _products[index];
                return Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    final isSelected = cart.contains(product);
                    return Card(
                      color: Colors.white,
                      elevation: isSelected ? 4 : 1,
                      shadowColor: isSelected ? Theme.of(context).primaryColor.withOpacity(0.4) : Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: isSelected 
                          ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
                          : BorderSide.none,
                      ),
                      child: InkWell(
                        onTap: () {
                           if (!isSelected) {
                            cart.addProduct(product);
                          } else {
                            cart.removeProduct(product);
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.shopping_bag_outlined, color: Colors.grey[600]),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Checkbox(
                                value: isSelected,
                                activeColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (bool? value) {
                                  if (value == true) {
                                    cart.addProduct(product);
                                  } else {
                                    cart.removeProduct(product);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 16, 
              right: 16, 
              top: 16, 
              bottom: 16 + MediaQuery.of(context).padding.bottom // Add safe area padding manually if needed, but SafeArea widget is better
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, -4),
                  blurRadius: 16,
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (Provider.of<CartProvider>(context, listen: false).items.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selecciona al menos un producto')),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CheckoutScreen()),
                    );
                  },
                  child: Text('Pagar'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
