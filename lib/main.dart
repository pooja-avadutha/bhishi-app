import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/bhishi_provider.dart';
import 'core/app_theme.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => BhishiProvider(),
      child: const BhishiApp(),
    ),
  );
}

class BhishiApp extends StatelessWidget {
  const BhishiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bhishi Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Consumer<BhishiProvider>(
        builder: (context, provider, child) {
          return provider.isLoggedIn ? const MainScreen() : const LoginScreen();
        },
      ),
    );
  }
}