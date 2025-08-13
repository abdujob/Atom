import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'; // ⬅️ Import manquant

import 'screens/menu_screen.dart';
import 'models/cart.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialisation WebView pour Android
  if (defaultTargetPlatform == TargetPlatform.android) {
    WebViewPlatform.instance = SurfaceAndroidWebView();
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => Cart(),
      child: const RestaurantApp(),
    ),
  );
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Self-Service',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MenuScreen(),
    );
  }
}
