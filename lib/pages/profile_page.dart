import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  String _selectedExam = 'YKS';
  final List<String> _exams = ['YKS', 'LGS', 'TOEFL', 'ALES'];
  final TextEditingController _hoursCtrl = TextEditingController(text: '1');
  final TextEditingController _departmentCtrl = TextEditingController();

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _hoursCtrl.dispose();
    _departmentCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // TODO: Kaydedilen bilgileri backend ya da local storage'a gönder
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil kaydedildi!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!) as ImageProvider
                          : const AssetImage('assets/profile_pic.png'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.blue[800],
                          child: const Icon(Icons.edit, size: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Ad Soyad',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Lütfen adınızı girin' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedExam,
                decoration: const InputDecoration(
                  labelText: 'Çalışılan Sınav',
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),
                items: _exams.map((exam) {
                  return DropdownMenuItem(
                    value: exam,
                    child: Text(exam),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedExam = val!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hoursCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Günde Planlanan Çalışma Saat(ler)i',
                  prefixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Lütfen saat girin';
                  final num? hours = num.tryParse(value);
                  return (hours == null || hours <= 0) ? 'Geçerli bir sayı girin' : null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departmentCtrl,
                decoration: const InputDecoration(
                  labelText: 'İstenen Bölüm',
                  prefixIcon: Icon(Icons.work),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Lütfen bölüm girin' : null,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Bilgileri Kaydet'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
