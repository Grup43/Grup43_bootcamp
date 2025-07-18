import 'package:flutter/material.dart';
import 'package:educoach_flutter/pages/planner_page.dart';
import 'package:educoach_flutter/services/task_service.dart';
import 'package:educoach_flutter/services/gold_service.dart';
import 'profile_page.dart';
import 'shop_page.dart';
import 'study_session_page.dart'; // Added import for StudySessionPage
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedMinutes = 25;
  String _timerType = 'Zamanlayıcı'; // veya 'Kronometre'
  String _focusType = 'Derin Odaklanma';

  void _showTimerTypeDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Zamanlayıcı Türü Seç'),
        children: [
          SimpleDialogOption(
            child: Row(children: [Icon(Icons.hourglass_bottom), SizedBox(width: 8), Text('Zamanlayıcı')]),
            onPressed: () => Navigator.pop(context, 'Zamanlayıcı'),
          ),
          SimpleDialogOption(
            child: Row(children: [Icon(Icons.timer), SizedBox(width: 8), Text('Kronometre')]),
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
              children: [
                Text('Derin Odaklanma', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Yalnızca izinli listedeki uygulamalara erişilebilir.', style: TextStyle(fontSize: 12)),
              ],
            ),
            onPressed: () => Navigator.pop(context, 'Derin Odaklanma'),
          ),
          SimpleDialogOption(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

  @override
  void initState() {
    super.initState();
    GoldService().addListener(_onGoldChanged);
  }

  @override
  void dispose() {
    GoldService().removeListener(_onGoldChanged);
    super.dispose();
  }

  void _onGoldChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Dinamik ilerleme yüzdesi elde ediliyor
    final double progress = TaskService.progressToday();
    final int percent = (progress * 100).round();

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
                Icon(Icons.monetization_on, color: Colors.amber, size: 28),
                const SizedBox(width: 4),
                Text(
                  GoldService().totalGold.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
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
          // Bahçe zemini
          Positioned(
            bottom: 0,
            child: Image.asset(
              'assets/garden.png', // Bahçe görseli
              width: MediaQuery.of(context).size.width * 0.9,
              errorBuilder: (context, error, stackTrace) => Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 200,
                color: Colors.green[200],
                child: Center(child: Text('Bahçe görseli eksik')), // Placeholder
              ),
            ),
          ),

          // Dinamik Yuvarlak Zamanlayıcı
          Positioned(
            top: 80,
            child: Column(
              children: [
                // Kum saati ve odaklanma türü
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
                          Text(_focusType, style: TextStyle(fontWeight: FontWeight.bold)),
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
                      mainLabelStyle: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black87),
                      modifier: (double value) {
                        final min = (value ~/ 5) * 5;
                        return '$min';
                      },
                    ),
                    size: 220,
                  ),
                  onChange: (value) {
                    setState(() {
                      _selectedMinutes = (value ~/ 5) * 5;
                    });
                  },
                ),
                const SizedBox(height: 8),
                Text(_timerType, style: TextStyle(fontSize: 16, color: Colors.blue[800], fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (_focusType == 'Derin Odaklanma')
                  Text('Yalnızca izinli listedeki uygulamalara erişilebilir.', style: TextStyle(fontSize: 12, color: Colors.black54)),
                if (_focusType == 'Serbest Odaklanma')
                  Text('Tüm uygulamalara erişim serbest.', style: TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),

          // Ağaçlar
          Positioned(
            bottom: 300,
            left: MediaQuery.of(context).size.width * 0.15,
            child: Image.asset(
              'assets/tree_1.png',
              width: 60,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.park, color: Colors.green, size: 60),
            ),
          ),
          Positioned(
            bottom: 300,
            left: MediaQuery.of(context).size.width * 0.30,
            child: Image.asset(
              'assets/tree_2.png',
              width: 60,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.park, color: Colors.green, size: 60),
            ),
          ),

          // Dükkan Butonu (eski yerine alındı)
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
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.store, color: Colors.brown, size: 50),
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

          // Ders Çalış Butonu (gizlendi, yeni arayüzde yok)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[800],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'AI Koç',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Planlayıcı',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            // AI Koç sayfası (ileride eklenecek)
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PlannerPage()),
            ).then((_) {
              setState(() {}); // Planlayıcıya gidip gelince güncelle
            });
          }
        },
      ),
    );
  }
}
