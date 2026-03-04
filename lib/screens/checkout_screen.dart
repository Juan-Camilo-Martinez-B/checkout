import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/payment_method_model.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/payment_provider.dart';
import '../providers/purchase_provider.dart';
import '../utils/card_formatters.dart';
import 'success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form Controllers
  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cvcController = TextEditingController();
  final _expiryController = TextEditingController();
  
  String _cardType = 'Crédito'; // Default
  bool _saveMethod = false;
  PaymentMethod? _selectedSavedMethod;
  bool _useSavedMethod = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user != null) {
      Provider.of<PaymentProvider>(context, listen: false).fetchMethods(user.id!);
    }
  }

  void _processPayment() async {
    if (_useSavedMethod && _selectedSavedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecciona un método de pago guardado')),
      );
      return;
    }

    if (!_useSavedMethod) {
      if (!_formKey.currentState!.validate()) return;
    }

    // Logic to save purchase
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    final cart = Provider.of<CartProvider>(context, listen: false);
    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    final purchaseProvider = Provider.of<PurchaseProvider>(context, listen: false);

    if (user == null) return;

    // Save payment method if requested
    if (!_useSavedMethod && _saveMethod) {
      final last4 = _cardNumberController.text.substring(_cardNumberController.text.length - 4);
      final newMethod = PaymentMethod(
        userId: user.id!,
        cardType: _cardType,
        cardHolder: _cardNameController.text,
        last4: last4,
      );
      await paymentProvider.addMethod(newMethod);
    }

    // Save purchase
    await purchaseProvider.savePurchase(user.id!, cart.total, cart.items);

    if (!mounted) return;

    // Capture values before clearing cart
    final total = cart.total;
    final itemCount = cart.items.length;

    // Clear cart
    cart.clear();

    // Navigate to Success
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SuccessScreen(total: total, itemCount: itemCount)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final savedMethods = paymentProvider.savedMethods;

    // Auto-select option if methods exist
    if (savedMethods.isNotEmpty && !_useSavedMethod && _selectedSavedMethod == null) {
      // We'll just rely on the user toggling.
    }

    return Scaffold(
      appBar: AppBar(title: Text('Checkout Simulator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total a pagar', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                        Text(
                          '\$${cart.total.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                    Divider(height: 24),
                    Text(
                      '${cart.items.length} productos seleccionados',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 16),
                    ...cart.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.name, style: TextStyle(color: Colors.black87)),
                              Text('\$${item.price.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),

            // Payment Methods Header
            Text('Método de Pago', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 16),
            
            // Toggle for saved methods
            if (savedMethods.isNotEmpty)
              Container(
                margin: EdgeInsets.only(bottom: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                           setState(() {
                            _useSavedMethod = true;
                            if (_selectedSavedMethod == null && savedMethods.isNotEmpty) {
                              _selectedSavedMethod = savedMethods.first;
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _useSavedMethod ? Theme.of(context).primaryColor : Colors.white,
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                            border: Border.all(color: _useSavedMethod ? Theme.of(context).primaryColor : Colors.grey.shade300),
                          ),
                          child: Center(
                            child: Text(
                              'Guardados',
                              style: TextStyle(
                                color: _useSavedMethod ? Colors.white : Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                           setState(() {
                            _useSavedMethod = false;
                            _selectedSavedMethod = null;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_useSavedMethod ? Theme.of(context).primaryColor : Colors.white,
                            borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                            border: Border.all(color: !_useSavedMethod ? Theme.of(context).primaryColor : Colors.grey.shade300),
                          ),
                          child: Center(
                            child: Text(
                              'Nueva Tarjeta',
                              style: TextStyle(
                                color: !_useSavedMethod ? Colors.white : Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (_useSavedMethod) ...[
              DropdownButtonFormField<PaymentMethod>(
                value: _selectedSavedMethod,
                items: savedMethods.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(
                      '${method.cardType} •••• ${method.last4}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedSavedMethod = val;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Selecciona una tarjeta',
                  prefixIcon: Icon(Icons.wallet),
                ),
              ),
            ],

            if (!_useSavedMethod) ...[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Type Chips
                    Row(
                      children: [
                        ChoiceChip(
                          label: Text('Crédito'),
                          selected: _cardType == 'Crédito',
                          onSelected: (selected) => setState(() => _cardType = 'Crédito'),
                          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: _cardType == 'Crédito' ? Theme.of(context).primaryColor : Colors.black87,
                            fontWeight: _cardType == 'Crédito' ? FontWeight.bold : FontWeight.normal,
                          ),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: _cardType == 'Crédito' ? Theme.of(context).primaryColor : Colors.grey.shade300),
                          ),
                        ),
                        SizedBox(width: 12),
                        ChoiceChip(
                          label: Text('Débito'),
                          selected: _cardType == 'Débito',
                          onSelected: (selected) => setState(() => _cardType = 'Débito'),
                          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: _cardType == 'Débito' ? Theme.of(context).primaryColor : Colors.black87,
                            fontWeight: _cardType == 'Débito' ? FontWeight.bold : FontWeight.normal,
                          ),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: _cardType == 'Débito' ? Theme.of(context).primaryColor : Colors.grey.shade300),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    
                    // Card Number
                    TextFormField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Número de tarjeta',
                        hintText: '0000 0000 0000 0000',
                        prefixIcon: Icon(Icons.credit_card_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Requerido';
                        String cleanValue = value.replaceAll(' ', '');
                        if (!RegExp(r'^[0-9]{16}$').hasMatch(cleanValue)) return 'Debe tener 16 dígitos';
                        return null;
                      },
                      inputFormatters: [
                        CardNumberInputFormatter(),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Expiry and CVC
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _expiryController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Expira',
                              hintText: 'MM/YY',
                              prefixIcon: Icon(Icons.calendar_today_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Requerido';
                              if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(value)) return 'Formato MM/YY';
                              return null;
                            },
                            inputFormatters: [
                              CardDateInputFormatter(),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _cvcController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'CVV',
                              hintText: '123',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Requerido';
                              if (!RegExp(r'^[0-9]{3}$').hasMatch(value)) return '3 dígitos';
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Card Holder
                    TextFormField(
                      controller: _cardNameController,
                      decoration: InputDecoration(
                        labelText: 'Titular de la tarjeta',
                        hintText: 'Nombre como aparece en la tarjeta',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) => value!.isEmpty ? 'Requerido' : null,
                    ),
                    
                    SizedBox(height: 16),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Guardar tarjeta para futuros pagos'),
                      value: _saveMethod,
                      onChanged: (val) => setState(() => _saveMethod = val),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 32),
            SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _processPayment,
                  child: Text('Confirmar Pago \$${cart.total.toStringAsFixed(2)}'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
