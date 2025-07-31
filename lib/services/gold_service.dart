import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  double earnGold(double amount) {
    _checkDate();
    if (!canEarn(amount)) {
      final left = (dailyLimit - _todayGold).clamp(0, dailyLimit).toDouble();
      if (left > 0) {
        _totalGold += left;
        _todayGold += left;
        notifyListeners();
        return left;
      }
      return 0.0;
    }
    _totalGold += amount;
    _todayGold += amount;
    notifyListeners();
    return amount;
  }

  void resetGold() {
    _totalGold = 0.0;
    _todayGold = 0.0;
    notifyListeners();
  }
} 