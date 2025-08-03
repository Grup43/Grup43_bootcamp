import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<bool> purchaseItem(int cost) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return false;

  final docRef = FirebaseFirestore.instance.collection('userStats').doc(user.uid);

  try {
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        return false;
      }

      int coins = (snapshot.data()?['coins'] ?? 0);

      if (coins < cost) {
        return false;
      }

      coins = (coins - cost).clamp(0, double.infinity).toInt();

      transaction.update(docRef, {'coins': coins});
      return true;
    });
  } catch (e) {
    print("Purchase failed: $e");
    return false;
  }
}

Future<int> getUserCoins() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return 0;

  final doc = await FirebaseFirestore.instance
      .collection('userStats')
      .doc(user.uid)
      .get();

  return doc.data()?['coins'] ?? 0;
}
