import 'dart:async';
import 'package:flutter/material.dart';
import 'package:educoach_flutter/pages/planner_page.dart';
import 'package:educoach_flutter/services/gold_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_page.dart';
import 'shop_page.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedMinutes = 25;
  String _timerType = 'Zamanlayıcı';
  String _focusType = 'Derin Odaklanma';

  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    GoldService().addListener(_onGoldChanged);
  }

  @override
  void dispose() {
    _timer?.cancel();
    GoldService().removeListener(_onGoldChanged);
    super.dispose();
  }

  void _onGoldChanged() {
    setState(() {});
  }

  void _showTimerTypeDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Zamanlayıcı Türü Seç'),
        children: [
          SimpleDialogOption(
            child: Row(children: const [
              Icon(Icons.hourglass_bottom),
              SizedBox(width: 8),
              Text('Zamanlayıcı')
            ]),
            onPressed: () => Navigator.pop(context, 'Zamanlayıcı'),
          ),
          SimpleDialogOption(
            child: Row(children: const [
              Icon(Icons.timer),
              SizedBox(width: 8),
              Text('Kronometre')
            ]),
            onPressed: () => Navigator.pop(context, 'Kronometre'),
          ),
        ],
      ),
    );
    if (result != null) setState(() => _timerType = result);
  }

  void _showFocusTypeDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Odaklanma Türü Seç'),
        children: [
          SimpleDialogOption(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Derin Odaklanma', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('İzinli uygulamalar dışında erişim kapalı.', style: TextStyle(fontSize: 12)),
              ],
            ),
            onPressed: () => Navigator.pop(context, 'Derin Odaklanma'),
          ),
          SimpleDialogOption(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Serbest Odaklanma', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Tüm uygulamalara erişim serbest.', style: TextStyle(fontSize: 12)),
              ],
            ),
            onPressed: () => Navigator.pop(context, 'Serbest Odaklanma'),
          ),
        ],
      ),
    );
    if (result != null) setState(() => _focusType = result);
  }

  void _startTimer() {
    setState(() {
      _remainingSeconds = _timerType == 'Zamanlayıcı' ? _selectedMinutes * 60 : 0;
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerType == 'Zamanlayıcı') {
        if (_remainingSeconds > 0) {
          setState(() => _remainingSeconds--);
        } else {
          _stopTimer();
          _giveReward();
        }
      } else {
        setState(() => _remainingSeconds++);
        if (_remainingSeconds % (15 * 60) == 0) {
          _giveReward();
        }
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  Future<void> _giveReward() async {
    double reward = 1;
    if (_selectedMinutes > 30) reward = 3;
    else if (_selectedMinutes > 15) reward = 2;

    if (_focusType == 'Derin Odaklanma') {
      reward *= 1.5;
    }

    final earned = await GoldService().earnGold(reward);

    await FirebaseFirestore.instance.collection('focusLogs').add({
      'userId': FirebaseAuth.instance.currentUser?.uid ?? 'guest',
      'minutes': _selectedMinutes,
      'deepFocus': _focusType == 'Derin Odaklanma',
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          earned > 0
              ? "Tebrikler! $earned altın kazandınız 🎉"
              : "Günlük altın limitine ulaştınız.",
        ),
      ),
    );
  }

  String _formatTime() {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text('EduCoach Bahçem'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              children: [
                const Icon(Icons.monetization_on,
                    color: Colors.amber, size: 28),
                const SizedBox(width: 4),
                Text(
                  "${GoldService().totalGold.toStringAsFixed(1)} Coins",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.account_circle, size: 32),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 0,
            child: Image.asset(
              'assets/garden.png',
              width: MediaQuery.of(context).size.width * 0.9,
              errorBuilder: (context, error, stackTrace) => Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 200,
                color: Colors.green[200],
                child: const Center(child: Text('Bahçe görseli eksik')),
              ),
            ),
          ),
          Positioned(
            top: 80,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.hourglass_bottom, color: Colors.blue[800]),
                      onPressed: _showTimerTypeDialog,
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _showFocusTypeDialog,
                      child: Row(
                        children: [
                          Icon(Icons.bolt, color: Colors.blue[800]),
                          const SizedBox(width: 4),
                          Text(_focusType, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SleekCircularSlider(
                  min: 5,
                  max: 120,
                  initialValue: _selectedMinutes.toDouble(),
                  appearance: CircularSliderAppearance(
                    customWidths: CustomSliderWidths(progressBarWidth: 16, trackWidth: 16),
                    customColors: CustomSliderColors(
                      progressBarColor: Colors.blue[800]!,
                      trackColor: Colors.blue[100]!,
                      dotColor: Colors.green,
                    ),
                    infoProperties: InfoProperties(
                      mainLabelStyle: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black87),
                      modifier: (double value) {
                        final min = (value ~/ 5) * 5;
                        return _isRunning ? _formatTime() : '$min';
                      },
                    ),
                    size: 220,
                  ),
                  onChange: !_isRunning
                      ? (value) {
                          setState(() {
                            _selectedMinutes = (value ~/ 5) * 5;
                          });
                        }
                      : null,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isRunning ? _stopTimer : _startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning ? Colors.red : Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(_isRunning ? 'Durdur' : 'Başlat'),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 90,
            right: 30,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShopPage()),
                ).then((_) => setState(() {}));
              },
              child: Column(
                children: [
                  Image.asset(
                    'assets/shop.png',
                    width: 50,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.store, color: Colors.brown, size: 50),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Dükkan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[800],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'AI Koç'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Planlayıcı'),
        ],
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PlannerPage()),
            ).then((_) {
              setState(() {});
            });
          }
        },
      ),
    );
  }
}
