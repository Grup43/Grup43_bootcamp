import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  final _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

      final user = userCredential.user;
      if (user != null) {
        final docRef = FirebaseFirestore.instance.collection('userStats').doc(user.uid);
        final snapshot = await docRef.get();

        if (!snapshot.exists) {
          await docRef.set({
            'coins': 0,
            'totalMinutes': 0,
            'tasksCompleted': 0,
            'streakDays': 0,
          });
        }
      }

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String msg = '';
      switch (e.code) {
        case 'user-not-found':
          msg = 'Bu e-posta ile kayıtlı bir hesap bulunamadı.';
          break;
        case 'wrong-password':
          msg = 'Şifre yanlış. Lütfen tekrar deneyin.';
          break;
        case 'invalid-email':
          msg = 'Geçersiz e-posta adresi.';
          break;
        case 'invalid-credential':
          msg = 'E-posta veya şifre hatalı.';
          break;
        default:
          msg = 'Bir hata oluştu: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Beklenmeyen bir hata oluştu.')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text('Giriş Yap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
