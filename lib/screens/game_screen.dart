import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../utils/score_calculator.dart';
import 'result_screen.dart';
import 'game_over_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameScreen extends StatefulWidget {
  final String difficulty;
  const GameScreen({super.key, required this.difficulty});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<String> kelimeListesi = [];
  late String hedefKelime = '';
  late DateTime baslangicZamani;
  List<String> tahminler = [];
  String aktifTahmin = "";
  Set<String> kullanilanHarfler = {}; // Harf takibi

  double get kutuBoyutu {
    switch (widget.difficulty) {
      case 'zor':
        return 38;
      case 'orta':
        return 42;
      default:
        return 50;
    }
  }

  @override
  void initState() {
    super.initState();
    kelimeYukle();
  }

  Future<void> kelimeYukle() async {
    String dosyaAdi = '';
    switch (widget.difficulty) {
      case 'kolay':
        dosyaAdi = 'assets/data/words_easy.json';
        break;
      case 'orta':
        dosyaAdi = 'assets/data/words_medium.json';
        break;
      case 'zor':
        dosyaAdi = 'assets/data/words_hard.json';
        break;
    }
    String jsonStr = await rootBundle.loadString(dosyaAdi);
    List<dynamic> jsonData = json.decode(jsonStr);
    kelimeListesi = jsonData.cast<String>();
    hedefKelime = kelimeListesi[Random().nextInt(kelimeListesi.length)].toLowerCase();
    print("🎯 Hedef Kelime (debug): $hedefKelime"); //Test mod içindir sonradan silinicek
    baslangicZamani = DateTime.now();
    setState(() {});
  }

  void harfEkle(String harf) {
    if (aktifTahmin.length < hedefKelime.length) {
      setState(() {
        aktifTahmin += harf.toLowerCase();
      });
    }
  }

  void harfSil() {
    if (aktifTahmin.isNotEmpty) {
      setState(() {
        aktifTahmin = aktifTahmin.substring(0, aktifTahmin.length - 1);
      });
    }
  }

  void tahminGonder() {
    String tahmin = aktifTahmin.toLowerCase();
    if (tahmin.length != hedefKelime.length || tahminler.contains(tahmin)) return;

    setState(() {
      tahminler.add(tahmin);
      kullanilanHarfler.addAll(tahmin.split(''));
      aktifTahmin = "";
    });

if (tahmin == hedefKelime) {
  int gecenSure = DateTime.now().difference(baslangicZamani).inSeconds;

  double puan = hesaplaPuan(
    zorluk: widget.difficulty,
    tahminSayisi: tahminler.length,
    sureSaniye: gecenSure,
  );

  // 🔥 SKORU FIREBASE'E YÜKLE
  FirebaseFirestore.instance.collection('scores').add({
    'oyuncu': aktifKullanici.kullaniciAdi,
    'puan': puan,
    'tarih': FieldValue.serverTimestamp(),
  });

  // ✅ Sonuç ekranına geç
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => ResultScreen(
        hedefKelime: hedefKelime,
        tahminSayisi: tahminler.length,
        sure: gecenSure,
        puan: puan,
      ),
    ),
  );
    } else if (tahminler.length >= 6) {
      setState(() {
        aktifKullanici.canSayisi = (aktifKullanici.canSayisi - 1).clamp(0, 5);
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GameOverScreen(hedefKelime: hedefKelime),
        ),
      );
    }
  }

  Color harfRenk(String tahmin, int index) {
    if (tahmin[index] == hedefKelime[index]) return Colors.green;
    if (hedefKelime.contains(tahmin[index])) return Colors.orange;
    return Colors.grey.shade700;
  }

  Widget buildKutular(String tahmin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(tahmin.length, (i) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.all(4),
          width: kutuBoyutu,
          height: kutuBoyutu,
          decoration: BoxDecoration(
            color: harfRenk(tahmin, i),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            tahmin[i].toUpperCase(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      }),
    );
  }

  Widget buildAktifInputKutular() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(hedefKelime.length, (i) {
        return Container(
          margin: const EdgeInsets.all(4),
          width: kutuBoyutu,
          height: kutuBoyutu,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade600),
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
          ),
          alignment: Alignment.center,
          child: Text(
            i < aktifTahmin.length ? aktifTahmin[i].toUpperCase() : '',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      }),
    );
  }

  Widget buildKlavye() {
    const alfabe = "ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZ";
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        ...alfabe.split('').map((harf) {
          final kullanildi = kullanilanHarfler.contains(harf.toLowerCase());
          return GestureDetector(
            onTap: () => harfEkle(harf),
            child: Container(
              padding: const EdgeInsets.all(8),
              width: 36,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: kullanildi ? Colors.grey.shade700 : Colors.grey.shade900,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade600),
              ),
              child: Text(
                harf,
                style: TextStyle(
                  color: kullanildi ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
        GestureDetector(
          onTap: harfSil,
          child: Container(
            width: 80,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.backspace_outlined, color: Colors.white),
          ),
        ),
        GestureDetector(
          onTap: tahminGonder,
          child: Container(
            width: 80,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.send, color: Colors.white),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (hedefKelime.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Kelime Oyunu - ${widget.difficulty.toUpperCase()}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              ...tahminler.map((t) => buildKutular(t)).toList(),
              const SizedBox(height: 24),
              buildAktifInputKutular(),
              const SizedBox(height: 32),
              buildKlavye(),
            ],
          ),
        ),
      ),
    );
  }
}
