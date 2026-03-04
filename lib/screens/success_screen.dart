import 'package:flutter/material.dart';

import 'product_list_screen.dart';

class SuccessScreen extends StatelessWidget {
  final double total;
  final int itemCount;

  const SuccessScreen({Key? key, required this.total, required this.itemCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout Simulator')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_rounded, color: Colors.green, size: 80),
              ),
              SizedBox(height: 32),
              Text(
                '¡Pago Exitoso!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Tu transacción ha sido procesada correctamente.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              
              // Receipt Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Text('Total Pagado', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                    SizedBox(height: 8),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 36, 
                        fontWeight: FontWeight.bold, 
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    SizedBox(height: 24),
                    Divider(),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Productos', style: TextStyle(color: Colors.grey[600])),
                        Text('$itemCount', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Fecha', style: TextStyle(color: Colors.grey[600])),
                        Text(
                          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => ProductListScreen()),
                      (route) => false,
                    );
                  },
                  child: Text('Volver a Comprar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
