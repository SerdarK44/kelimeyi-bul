import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';

Future<void> firebaseSkorKaydet({
  required String kullaniciAdi,
  required double puan,
  required int sure,
  required int tahmin,
}) async {
  try {
    await FirebaseFirestore.instance.collection("scores").add({
      "kullaniciAdi": kullaniciAdi,
      "puan": puan,
      "sure": sure,
      "tahmin": tahmin,
      "tarih": DateTime.now(),
    });

    print("✅ Skor Firestore'a kaydedildi.");
  } catch (e) {
    print("❌ Skor kaydetme hatası: $e");
  }
}

Future<void> guncelleToplamSkor(String kullaniciAdi, double yeniSkor) async {
  final ref = FirebaseFirestore.instance.collection("leaderboard").doc(kullaniciAdi);

  try {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);
      final mevcutSkor = snapshot.exists ? (snapshot.data()?["toplamSkor"] ?? 0) : 0;
      final yeniToplam = mevcutSkor + yeniSkor;

      transaction.set(ref, {
        "kullaniciAdi": kullaniciAdi,
        "toplamSkor": yeniToplam,
      });
    });

    print("✅ Toplam skor güncellendi.");
  } catch (e) {
    print("❌ Toplam skor güncelleme hatası: $e");
  }
}

Future<void> friendRequestGonder(String hedefKullanici) async {
  try {
    final ref = FirebaseFirestore.instance
        .collection('friend_requests')
        .doc(hedefKullanici)
        .collection('list')
        .doc(aktifKullanici.kullaniciAdi);

    await ref.set({
      'gonderen': aktifKullanici.kullaniciAdi,
      'tarih': FieldValue.serverTimestamp(),
    });

    print("✅ Arkadaşlık isteği gönderildi.");
  } catch (e) {
    print("❌ Arkadaşlık isteği gönderme hatası: $e");
  }
}
