import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/planner_page.dart';
import 'pages/coach_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        '/coach': (context) =>  CoachPage(),
      },
    );
  }
}
