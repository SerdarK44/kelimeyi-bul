import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class FriendRequestsScreen extends StatelessWidget {
  const FriendRequestsScreen({super.key});

  Future<void> istegiKabulEt(BuildContext context, String gonderenAdi) async {
    try {
      // 1. iki kullanıcıyı da friends koleksiyonuna ekle
      await FirebaseFirestore.instance
          .collection('friends')
          .doc(aktifKullanici.kullaniciAdi)
          .collection('list')
          .doc(gonderenAdi)
          .set({
        'arkadasAdi': gonderenAdi,
        'canSayisi': 0,
        'gonderimTarihi': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('friends')
          .doc(gonderenAdi)
          .collection('list')
          .doc(aktifKullanici.kullaniciAdi)
          .set({
        'arkadasAdi': aktifKullanici.kullaniciAdi,
        'canSayisi': 0,
        'gonderimTarihi': FieldValue.serverTimestamp(),
      });

      // 2. istek sil
      await FirebaseFirestore.instance
          .collection('friend_requests')
          .doc(aktifKullanici.kullaniciAdi)
          .collection('list')
          .doc(gonderenAdi)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$gonderenAdi ile arkadaş oldunuz!')),
      );
    } catch (e) {
      debugPrint('İstek kabul hatası: $e');
    }
  }

  Future<void> istegiReddet(BuildContext context, String gonderenAdi) async {
    try {
      await FirebaseFirestore.instance
          .collection('friend_requests')
          .doc(aktifKullanici.kullaniciAdi)
          .collection('list')
          .doc(gonderenAdi)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$gonderenAdi isteği reddedildi.')),
      );
    } catch (e) {
      debugPrint('İstek reddet hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text('Gelen İstekler'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('friend_requests')
            .doc(aktifKullanici.kullaniciAdi)
            .collection('list')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final istekler = snapshot.data!.docs;

          if (istekler.isEmpty) {
            return const Center(
              child: Text(
                "Henüz istek yok...",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: istekler.length,
            itemBuilder: (context, index) {
              final data = istekler[index].data() as Map<String, dynamic>;
              final gonderen = data['gonderen'] ?? "Bilinmeyen";

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    gonderen,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                  ),
                  subtitle: Text(
                    "Arkadaşlık isteği gönderdi",
                    style: GoogleFonts.poppins(color: Colors.white60, fontSize: 14),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle, color: Colors.greenAccent),
                        onPressed: () => istegiKabulEt(context, gonderen),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.redAccent),
                        onPressed: () => istegiReddet(context, gonderen),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
