import 'package:flutter/material.dart';
import '../main.dart';
import '../models/score_model.dart';
import 'home_screen.dart';
import '../services/firebase_service.dart';

class ResultScreen extends StatefulWidget {
  final String hedefKelime;
  final int tahminSayisi;
  final int sure;
  final double puan;

  const ResultScreen({
    super.key,
    required this.hedefKelime,
    required this.tahminSayisi,
    required this.sure,
    required this.puan,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  @override
  void initState() {
    super.initState();
    kayitlariYap();
  }

  Future<void> kayitlariYap() async {
    await firebaseSkorKaydet(
      kullaniciAdi: aktifKullanici.kullaniciAdi,
      puan: widget.puan,
      sure: widget.sure,
      tahmin: widget.tahminSayisi,
    );

    await guncelleToplamSkor(
      aktifKullanici.kullaniciAdi,
      widget.puan,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sonuç Ekranı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("🎯 Doğru Kelime: ${widget.hedefKelime}", style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 12),
              Text("🧠 Tahmin Sayısı: ${widget.tahminSayisi}", style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 12),
              Text("⏱️ Süre: ${widget.sure} saniye", style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 12),
              Text("💯 Puan: ${widget.puan.toStringAsFixed(2)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text("Ana Sayfaya Dön"),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
