import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final user = FirebaseAuth.instance.currentUser;

  Future<List<Map<String, dynamic>>> _fetchItems() async {
    if (user == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('userInventory')
        .doc(user!.uid)
        .collection('items')
        .get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envanterim'),
        backgroundColor: Colors.blue[800],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Envanterde ürün bulunmuyor.'));
          }

          final items = snapshot.data!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.star, color: Colors.amber, size: 32),
                  title: Text(item['id']),
                  subtitle: Text("Satın alma tarihi: ${(item['purchasedAt'] as Timestamp?)?.toDate().toString().split(' ')[0] ?? 'Bilinmiyor'}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
