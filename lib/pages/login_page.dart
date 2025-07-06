import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  void _login() {
    setState(() => _loading = true);
    // TODO: Burada backend ile gerçek doğrulama yapın
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() => _loading = false);
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],      // HomePage arka planıyla uyumlu
      appBar: AppBar(
        backgroundColor: Colors.blue[800],    // HomePage AppBar rengi
        title: const Text('Giriş Yap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // E-Posta Alanı
            TextField(
              controller: _emailCtrl,
              style: const TextStyle(color: Colors.black87),
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.blue[800],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'E-posta',
                prefixIcon: const Icon(Icons.email, color: Colors.blue),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[800]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[800]!),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Şifre Alanı
            TextField(
              controller: _passCtrl,
              style: const TextStyle(color: Colors.black87),
              obscureText: true,
              cursorColor: Colors.blue[800],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Şifre',
                prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[800]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[800]!),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Giriş Butonu
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Giriş Yap', style: TextStyle(fontSize: 16)),
                  ),
            const SizedBox(height: 16),
            // Kayıt Linki
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/register');
              },
              child: const Text(
                'Hesabın yok mu? Kayıt ol',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
