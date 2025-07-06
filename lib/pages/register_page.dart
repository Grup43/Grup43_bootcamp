import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  void _register() {
    setState(() => _loading = true);
    // TODO: Burada backend ile kullanıcı oluşturma yapın
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() => _loading = false);
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200], // HomePage uyumlu arka plan
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text('Kayıt Ol'),
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
            // Kayıt Butonu
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Kayıt Ol', style: TextStyle(fontSize: 16)),
                  ),
            const SizedBox(height: 16),
            // Giriş Linki
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                'Zaten hesabın var mı? Giriş yap',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
