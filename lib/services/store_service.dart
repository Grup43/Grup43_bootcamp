import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Ürün satın alma ve coin düşürme
  Future<void> purchaseItem(String itemId, double price) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userStatsRef = _db.collection('userStats').doc(user.uid);
    final inventoryRef = _db
        .collection('userInventory')
        .doc(user.uid)
        .collection('items')
        .doc(itemId);

    await _db.runTransaction((transaction) async {
      final statsSnapshot = await transaction.get(userStatsRef);
      final currentCoins = (statsSnapshot['coins'] ?? 0).toDouble();

      if (currentCoins >= price) {
        transaction.update(userStatsRef, {'coins': currentCoins - price});

        transaction.set(inventoryRef, {
          'active': true,
          'purchasedAt': FieldValue.serverTimestamp(),
        });
      } else {
        throw Exception("Yetersiz coin!");
      }
    });
  }

  /// Kullanıcı ürününü aktif eder
  Future<void> activateItem(String itemId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _db
        .collection('userInventory')
        .doc(user.uid)
        .collection('items')
        .doc(itemId)
        .set({'active': true}, SetOptions(merge: true));
  }

  /// Aktif ürünleri getir
  Future<List<Map<String, dynamic>>> getActiveItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final query = await _db
        .collection('userInventory')
        .doc(user.uid)
        .collection('items')
        .where('active', isEqualTo: true)
        .get();

    return query.docs.map((doc) => doc.data()).toList();
  }
}
