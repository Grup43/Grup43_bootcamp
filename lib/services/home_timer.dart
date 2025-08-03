import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class HomeTimer extends StatefulWidget {
  @override
  _HomeTimerState createState() => _HomeTimerState();
}

class _HomeTimerState extends State<HomeTimer> {
  int _selectedMinutes = 45;
  int _remainingSeconds = 0;
  bool _isRunning = false;
  Timer? _timer;

  void _startTimer() {
    setState(() {
      _remainingSeconds = _selectedMinutes * 60;
      _isRunning = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _stopTimer();
        await _giveReward();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  Future<void> _giveReward() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef =
        FirebaseFirestore.instance.collection('userStats').doc(user.uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        transaction.set(docRef, {
          'coins': 0,
          'totalMinutes': 0,
          'tasksCompleted': 0,
          'streakDays': 0,
        });
      }

      final data = snapshot.data() ?? {};
      int coins = (data['coins'] ?? 0);
      coins += _selectedMinutes > 30 ? 3 : _selectedMinutes > 15 ? 2 : 1;

      transaction.update(docRef, {'coins': coins});
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('🎉 Süre tamamlandı, ödül kazandınız!')),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayMinutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final displaySeconds = (_remainingSeconds % 60).toString().padLeft(2, '0');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SleekCircularSlider(
          initialValue: _selectedMinutes.toDouble(),
          min: 5,
          max: 120,
          onChange: (val) {
            if (!_isRunning) {
              setState(() => _selectedMinutes = val.toInt());
            }
          },
          innerWidget: (_) => Center(
            child: Text(
              _isRunning ? '$displayMinutes:$displaySeconds' : '$_selectedMinutes',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isRunning ? _stopTimer : _startTimer,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: Size(150, 50),
          ),
          child: Text(_isRunning ? 'Durdur' : 'Başlat'),
        ),
      ],
    );
  }
}
