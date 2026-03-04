import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/purchase_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Immersive UI: Set System UI Overlay Style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness: Brightness.dark, // Dark icons on status bar
      systemNavigationBarColor: Colors.transparent, // Transparent navigation bar
      systemNavigationBarIconBrightness: Brightness.dark, // Dark icons on navigation bar
    ),
  );
  
  // Make the app draw behind the system bars
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => PurchaseProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Checkout Flutter',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4C6EF5), // Indigo/Blue from the image
            primary: const Color(0xFF4C6EF5),
            secondary: const Color(0xFF6C757D),
            background: const Color(0xFFF8F9FA),
            surface: Colors.white,
          ),
          scaffoldBackgroundColor: const Color(0xFFF8F9FA),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.black87),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C6EF5),
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4C6EF5), width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            labelStyle: const TextStyle(color: Colors.grey),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // Customizing Text Theme for better readability
          textTheme: TextTheme(
            titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87), // Page Headers
            titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87), // Section Headers
            bodyLarge: TextStyle(fontSize: 16, color: Colors.black87), // Normal text
            bodyMedium: TextStyle(fontSize: 14, color: Colors.black54), // Secondary text
          ),
        ),
        home: LoginScreen(),
      ),
    );
  }
}
