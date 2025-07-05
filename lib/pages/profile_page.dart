import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // Profil fotoğrafı
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_pic.png'), // Profil resmi eklemeyi unutma
            ),
            const SizedBox(height: 20),

            // Kullanıcı adı
            const Text(
              'Sena Yüksel',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            const Text(
              '11113',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 40),

            // Çıkış butonu
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Çıkış Yap'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context); // Şimdilik sadece geri dönüyor
              },
            ),
          ],
        ),
      ),
    );
  }
}
