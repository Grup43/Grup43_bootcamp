import 'package:flutter/material.dart';
import 'package:educoach_flutter/pages/planner_page.dart';
import 'package:educoach_flutter/services/task_service.dart';
import 'profile_page.dart';
import 'shop_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            child: IconButton(
              icon: const Icon(Icons.account_circle, size: 32),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
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
              'assets/garden.png',
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          ),

          // Ağaçlar
          Positioned(
            bottom: 300,
            left: MediaQuery.of(context).size.width * 0.15,
            child: Image.asset('assets/tree_1.png', width: 60),
          ),
          Positioned(
            bottom: 300,
            left: MediaQuery.of(context).size.width * 0.30,
            child: Image.asset('assets/tree_2.png', width: 60),
          ),

          // Günlük Hedef ve İlerleme
          Positioned(
            top: 80,
            child: Column(
              children: [
                const Text(
                  'Günlük Hedef',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 7,
                        color: Colors.blue[800],
                        backgroundColor: Colors.white,
                      ),
                    ),
                    Text(
                      '$percent%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Dükkan Butonu
          Positioned(
            bottom: 90,
            right: 30,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShopPage()),
                ).then((_) {
                  setState(() {}); // Planlayıcıdan dönüldüğünde güncelle
                });
              },
              child: Column(
                children: [
                  Image.asset('assets/shop.png', width: 50),
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
