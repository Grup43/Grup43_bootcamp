
import 'package:flutter/material.dart';

class CoachPage extends StatelessWidget {
  const CoachPage({super.key});  // 🔑 Buraya const ekledik

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coach Page')),
      body: const Center(child: Text('Coach Content')),
    );
  }
}

