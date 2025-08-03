import 'package:flutter/material.dart';
import 'package:educoach_flutter/services/gold_service.dart';
import 'dart:async';
import 'package:educoach_flutter/services/task_service.dart';

class StudySessionPage extends StatefulWidget {
  @override
  _StudySessionPageState createState() => _StudySessionPageState();
}

class _StudySessionPageState extends State<StudySessionPage> {
  int? _selectedMinutes;
  bool _isRunning = false;
  int _remainingSeconds = 0;
  late final List<int> _durations = [15, 30, 60, 120];
  late final Map<int, double> _goldRewards = {
    15: 0.2,
    30: 0.3,
    60: 0.5,
    120: 1.0,
  };

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startSession() {
    if (_selectedMinutes == null) return;
    setState(() {
      _isRunning = true;
      _remainingSeconds = _selectedMinutes! * 60;
    });
    _timer = _tick();
  }

  Future<void> _endSession({bool completed = false}) async {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = 0;
    });

    if (completed) {
      final reward = _goldRewards[_selectedMinutes] ?? 0.0;
      final earned = await GoldService().earnGold(reward);

      String msg;
      if (earned == 0.0) {
        msg = 'Günlük altın limitine ulaştın! Bugün daha fazla altın kazanamazsın.';
      } else if (earned < reward) {
        msg = 'Günlük limit nedeniyle sadece +$earned altın kazandın!';
      } else {
        msg = 'Ders süresini tamamladın. +$earned altın kazandın!';
      }

      TaskService.markStudyToday();

      // Streak bonusu (async olarak)
      double bonus = 0.0;
      if (TaskService.streak == 3) bonus = await GoldService().earnGold(1.0); // 3 gün üst üste
      if (TaskService.streak == 5) bonus = await GoldService().earnGold(1.0); // 5 gün üst üste
      if (TaskService.streak == 10) bonus = await GoldService().earnGold(2.0); // 10 gün üst üste

      if (bonus > 0) {
        msg += '\nStreak bonusu: +$bonus altın! (Seri: ${TaskService.streak} gün)';
      } else if (TaskService.streak > 1) {
        msg += '\nSerin: ${TaskService.streak} gün!';
      }

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Tebrikler!'),
          content: Text(msg),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam'))],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Seans Erken Bitirildi'),
          content: const Text('Süre dolmadan bitirdiğin için ödül yok.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam'))],
        ),
      );
    }
  }

  Timer _tick() {
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        _endSession(completed: true);
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ders Çalış'),
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
        child: _isRunning
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.stop),
                    label: const Text('Bitir (Ödül Yok)'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => _endSession(completed: false),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Süre Seç', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    children: _durations.map((min) => ChoiceChip(
                      label: Text('$min dk'),
                      selected: _selectedMinutes == min,
                      onSelected: (selected) {
                        setState(() => _selectedMinutes = min);
                      },
                    )).toList(),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Başla'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      minimumSize: const Size(140, 48),
                    ),
                    onPressed: _selectedMinutes != null ? _startSession : null,
                  ),
                ],
              ),
      ),
    );
  }
}
