import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/planner_page.dart';
import 'pages/inventory_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  try {
    await dotenv.load(fileName: ".env");
    print(' .env loaded successfully');
  } catch (e) {
    print(' Failed to load .env: $e');
  }


  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print(' Firebase initialized successfully');
  } catch (e) {
    print(' Firebase initialization failed: $e');
  }

  // ✅ Türkçe tarih formatlarını yükle
  await initializeDateFormatting('tr_TR', null);

  runApp(const EduCoachApp());
}

class EduCoachApp extends StatelessWidget {
  const EduCoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduCoach',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/planner': (context) => const PlannerPage(),
'/inventory': (context) => const InventoryPage(),
      },
    );
  }
}
