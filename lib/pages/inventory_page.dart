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
  late final CollectionReference itemsRef;

  @override
  void initState() {
    super.initState();
    itemsRef = FirebaseFirestore.instance
        .collection('userInventory')
        .doc(user!.uid)
        .collection('items');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envanterim'),
        backgroundColor: Colors.blue[800],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: itemsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Henüz hiç ürün satın almadın.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final items = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index].data() as Map<String, dynamic>;
              final name = item['name'] ?? 'Ürün';
              final image = item['image'] ?? '';

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    image.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.shopping_bag, size: 60, color: Colors.brown),
                    const SizedBox(height: 10),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
