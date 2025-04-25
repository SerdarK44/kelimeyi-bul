import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'home_screen.dart';

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  TextEditingController _controller = TextEditingController();
  bool isLoading = true;
  String? hataMesaji;

  @override
  void initState() {
    super.initState();
    kontrolEt();
  }

  Future<void> kontrolEt() async {
    final prefs = await SharedPreferences.getInstance();
    final isim = prefs.getString("kullaniciAdi");
    if (isim != null && isim.isNotEmpty) {
      aktifKullanici.kullaniciAdi = isim;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> kaydetVeGec() async {
    final girilenAd = _controller.text.trim();
    if (girilenAd.length < 3) {
      setState(() => hataMesaji = "Kullanıcı adı en az 3 karakter olmalı.");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("kullaniciAdi", girilenAd);
    aktifKullanici.kullaniciAdi = girilenAd;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Hoş Geldin")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Lütfen kullanıcı adını gir:",
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Örn: reis123",
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            if (hataMesaji != null) ...[
              const SizedBox(height: 12),
              Text(hataMesaji!, style: const TextStyle(color: Colors.redAccent)),
            ],
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Başla"),
              onPressed: kaydetVeGec,
            ),
          ],
        ),
      ),
    );
  }
}
