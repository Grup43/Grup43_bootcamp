
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/planner_page.dart';
import 'pages/coach_page.dart';

void main() {
  runApp(EduCoachApp());
}

class EduCoachApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduCoach',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/planner': (context) => PlannerPage(),
        '/coach': (context) => CoachPage(),
      },
    );
  }
}
