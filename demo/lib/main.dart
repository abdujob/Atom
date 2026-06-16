import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants/app_constants.dart';
import 'screens/splash_screen.dart';
import 'models/cart.dart';
import 'services/database_service.dart';
import 'services/data_initialization_service.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Mode plein écran (kiosk)
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await DatabaseService.initDatabase();
  await AuthService.initAuthService();

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
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppConstants.appTheme,
      home: const SplashScreen(),
    );
  }
}

