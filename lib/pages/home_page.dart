import 'package:educoach_flutter/pages/profile_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            child: IconButton(
              icon: const Icon(Icons.account_circle, size: 32),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
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
            child: Image.asset(
              'assets/tree_1.png',
              width: 60,
            ),
          ),
          Positioned(
            bottom: 300,
            left: MediaQuery.of(context).size.width * 0.30,
            child: Image.asset(
              'assets/tree_2.png',
              width: 60,
            ),
          ),

          // Günlük Hedef Yazısı
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
                // İlerleme göstergesi
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: CircularProgressIndicator(
                        value: 0.7, // %70 ilerleme
                        strokeWidth: 7,
                        color: Colors.blue[800],
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const Text('70%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      // Alt menü
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
          // yönlendirmeleri burada yapabilirsin
        },
      ),
    );
  }
}
