import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoldService extends ChangeNotifier {
  static final GoldService _instance = GoldService._internal();
  factory GoldService() => _instance;
  GoldService._internal();

  double _totalGold = 0.0;
  double _todayGold = 0.0;
  final double dailyLimit = 5.0;
  String _lastGoldDate = _todayKey();

  static String _todayKey() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  double get totalGold => _totalGold;
  double get todayGold {
    _checkDate();
    return _todayGold;
  }

  void _checkDate() {
    final today = _todayKey();
    if (_lastGoldDate != today) {
      _todayGold = 0.0;
      _lastGoldDate = today;
      notifyListeners();
    }
  }

  bool canEarn(double amount) {
    _checkDate();
    return (_todayGold + amount) <= dailyLimit;
  }

  Future<double> earnGold(double amount) async {
    _checkDate();
    double earned = amount;

    if (!canEarn(amount)) {
      final left = (dailyLimit - _todayGold).clamp(0, dailyLimit).toDouble();
      if (left > 0) {
        _totalGold += left;
        _todayGold += left;
        earned = left;
      } else {
        earned = 0.0;
      }
    } else {
      _totalGold += amount;
      _todayGold += amount;
    }

    notifyListeners();
    await _updateFirestore();

    return earned;
  }

  Future<void> loadGoldFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('userStats')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      _totalGold = (data['coins'] ?? 0).toDouble();
      notifyListeners();
    }
  }

  Future<void> _updateFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('userStats')
        .doc(user.uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        transaction.set(docRef, {
          'coins': _totalGold,
          'totalMinutes': 0,
          'tasksCompleted': 0,
          'streakDays': 0,
        });
      } else {
        transaction.update(docRef, {'coins': _totalGold});
      }
    });
  }

  void resetGold() {
    _totalGold = 0.0;
    _todayGold = 0.0;
    notifyListeners();
    _updateFirestore();
  }
}
