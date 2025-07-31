import 'package:flutter/material.dart';
import 'package:educoach_flutter/services/gold_service.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final List<_ShopItem> items = [
    _ShopItem('Çiçek', 1.0, 'assets/tree_3.png'),
    _ShopItem('Pembe Ağaç', 2.0, 'assets/tree_4.png'),
    _ShopItem('Bahçe Arka Planı', 3.0, 'assets/garden_bg.png'),
    _ShopItem('Altın Taç (Avatar)', 5.0, null),
  ];

  void _buyItem(_ShopItem item) {
    if (GoldService().totalGold < item.price) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Yetersiz Altın'),
          content: const Text('Bu ürünü almak için yeterli altının yok!'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam'))],
        ),
      );
      return;
    }
    GoldService().earnGold(-item.price); // Altın düşür
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Satın Alındı!'),
        content: Text('${item.name} başarıyla satın alındı!'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam'))],
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dükkan'),
        backgroundColor: Colors.blue[800],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: items.map((item) => Card(
          child: ListTile(
            leading: item.assetPath != null ? Image.asset(item.assetPath!, width: 40, height: 40, errorBuilder: (c,e,s)=>Icon(Icons.image)) : Icon(Icons.emoji_events, color: Colors.amber, size: 40),
            title: Text(item.name),
            subtitle: Text('${item.price} altın'),
            trailing: ElevatedButton(
              onPressed: () => _buyItem(item),
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
  final double price;
  final String? assetPath;
  _ShopItem(this.name, this.price, this.assetPath);
}
