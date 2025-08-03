import 'package:flutter/material.dart';
import 'package:educoach_flutter/services/store_service.dart';
import 'package:educoach_flutter/services/gold_service.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final StoreService _storeService = StoreService();

  final List<Map<String, dynamic>> _items = [
    {'id': 'flower_1', 'name': 'Çiçek 1', 'price': 2.0},
    {'id': 'tree_1', 'name': 'Ağaç 1', 'price': 5.0},
    {'id': 'bench_1', 'name': 'Bank 1', 'price': 3.0},
  ];

  Future<void> _buyItem(String itemId, double price) async {
    try {
      await _storeService.purchaseItem(itemId, price);
      await GoldService().loadGoldFromFirestore();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$itemId başarıyla satın alındı ve aktif edildi!')),
      );

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Satın alma başarısız: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dükkan'),
        backgroundColor: Colors.blue[800],
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: Text(item['name']),
            trailing: ElevatedButton(
              onPressed: () => _buyItem(item['id'], item['price']),
              child: Text('${item['price']} Coins'),
            ),
          );
        },
      ),
    );
  }
}
