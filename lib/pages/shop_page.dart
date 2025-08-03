import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/store_service.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final List<_ShopItem> items = [
    _ShopItem('Çiçek', 1, 'assets/tree_3.png'),
    _ShopItem('Pembe Ağaç', 2, 'assets/tree_4.png'),
    _ShopItem('Bahçe Arka Planı', 3, 'assets/garden_bg.png'),
    _ShopItem('Altın Taç (Avatar)', 5, null),
  ];

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dükkan'),
        backgroundColor: Colors.blue[800],
        actions: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('userStats')
                .doc(userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Padding(
                padding: EdgeInsets.all(16),
                child: Text("Coins: 0"),
              );
              int coins = snapshot.data?['coins'] ?? 0;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text("Coins: $coins"),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: items.map((item) => Card(
          child: ListTile(
            leading: item.assetPath != null 
                ? Image.asset(item.assetPath!, width: 40, height: 40, errorBuilder: (c,e,s)=>const Icon(Icons.image)) 
                : const Icon(Icons.emoji_events, color: Colors.amber, size: 40),
            title: Text(item.name),
            subtitle: Text('${item.price} altın'),
            trailing: ElevatedButton(
              onPressed: () async {
                bool success = await purchaseItem(item.price);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success 
                      ? 'Satın alındı!' 
                      : 'Yetersiz altın')),
                );
              },
              child: const Text('Satın Al'),
            ),
          ),
        )).toList(),
      ),
    );
  }
}

class _ShopItem {
  final String name;
  final int price;
  final String? assetPath;
  _ShopItem(this.name, this.price, this.assetPath);
}
