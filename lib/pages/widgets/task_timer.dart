import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskTimer extends StatefulWidget {
  final int durationInMinutes;
  final String taskId;

  TaskTimer({required this.durationInMinutes, required this.taskId});

  @override
  _TaskTimerState createState() => _TaskTimerState();
}

class _TaskTimerState extends State<TaskTimer> {
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isRunning = false;

  void _startTimer() {
    setState(() {
      _remainingSeconds = widget.durationInMinutes * 60;
      _isRunning = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _stopTimer();
        _markTaskCompleted();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  Future<void> _markTaskCompleted() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('userStats')
        .doc(user.uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        transaction.set(docRef, {
          'coins': 0,
          'totalMinutes': 0,
          'tasksCompleted': 0,
          'streakDays': 0
        });
      }

      final data = snapshot.data() ?? {};
      int coins = (data['coins'] ?? 0);
      int totalMinutes = (data['totalMinutes'] ?? 0);
      int tasksCompleted = (data['tasksCompleted'] ?? 0);

      int earnedCoins = 1;
      if (widget.durationInMinutes > 30) {
        earnedCoins = 3;
      } else if (widget.durationInMinutes > 15) {
        earnedCoins = 2;
      }

      coins += earnedCoins;
      totalMinutes += widget.durationInMinutes;
      tasksCompleted += 1;

      transaction.update(docRef, {
        'coins': coins,
        'totalMinutes': totalMinutes,
        'tasksCompleted': tasksCompleted,
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');

    return Column(
      children: [
        Text('$minutes:$seconds',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        ElevatedButton(
          onPressed: _isRunning ? _stopTimer : _startTimer,
          child: Text(_isRunning ? 'Stop' : 'Start'),
        ),
      ],
    );
  }
}
