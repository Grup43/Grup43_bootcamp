import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dükkan'),
        backgroundColor: Colors.blue[800],
      ),
      body: const Center(
        child: Text('Burada çiçek satın alma ekranı olacak.'),
      ),
    );
  }
}
