import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/giris_ekrani.dart';
import 'models/score_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 🔥 Firestore eklendi

// 👤 Kullanıcı Modeli
class UserModel {
  String id;
  String kullaniciAdi;
  int canSayisi;
  DateTime lastLifeRefill;

  UserModel({
    required this.id,
    required this.kullaniciAdi,
    required this.canSayisi,
    required this.lastLifeRefill,
  });
}

// 🌍 Global Kullanıcı ve Skorlar
UserModel aktifKullanici = UserModel(
  id: "1",
  kullaniciAdi: "",
  canSayisi: 3,
  lastLifeRefill: DateTime.now().subtract(const Duration(hours: 2)),
);

List<Skor> globalSkorlar = [];

// ⏱️ Can Yenileme Kontrolü
void canYenileKontrol() {
  final simdi = DateTime.now();
  if (aktifKullanici.canSayisi >= 5) return;

  final fark = simdi.difference(aktifKullanici.lastLifeRefill);
  if (fark.inHours >= 1) {
    int dolacakCan = fark.inHours;
    aktifKullanici.canSayisi = (aktifKullanici.canSayisi + dolacakCan).clamp(0, 5);
    aktifKullanici.lastLifeRefill = simdi;

    print("⏱️ Can yenilendi! Yeni can: ${aktifKullanici.canSayisi}");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 🔥 Firestore bağlantı kontrolü
  try {
    await FirebaseFirestore.instance.collection('scores').limit(1).get();
    print("✅ Firestore bağlantısı başarılı");
  } catch (e) {
    print("❌ Firestore bağlantı hatası: $e");
  }

  canYenileKontrol();
  print("📱 Uygulama başlatılıyor...");
  runApp(const KelimeOyunuApp());
}

class KelimeOyunuApp extends StatelessWidget {
  const KelimeOyunuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelime Oyunu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(fontSize: 18),
            backgroundColor: const Color(0xFF6C63FF),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const GirisEkrani(),
    );
  }
}
