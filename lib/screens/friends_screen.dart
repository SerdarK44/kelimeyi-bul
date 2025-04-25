import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'add_friend_screen.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

Future<void> canGonder(BuildContext context, String arkadasAdi) async {
  if (aktifKullanici.canSayisi <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Yetersiz can! Can göndermek için en az 1 canın olmalı.")),
    );
    return;
  }

  final ref = FirebaseFirestore.instance
      .collection('friends')
      .doc(aktifKullanici.kullaniciAdi)
      .collection('list')
      .doc(arkadasAdi);

  try {
    final snapshot = await ref.get();
    final data = snapshot.data();

    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Arkadaş verisi bulunamadı.")),
      );
      return;
    }

    final mevcutCan = data['canSayisi'] ?? 0;
    if (mevcutCan >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bu kullanıcı zaten maksimum 5 cana sahip!")),
      );
      return;
    }

    // ✅ Firestore güncelleme
    await ref.update({
      'canSayisi': FieldValue.increment(1),
      'gonderimTarihi': FieldValue.serverTimestamp(),
    });

    // ✅ Gönderenin canını düşür
    aktifKullanici.canSayisi = (aktifKullanici.canSayisi - 1).clamp(0, 5);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$arkadasAdi kişisine 1 can gönderildi!')),
    );
  } catch (e) {
    debugPrint('Can gönderme hatası: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bir hata oluştu, tekrar deneyin.")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text('Arkadaşlarım'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddFriendScreen()));
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('friends')
            .doc(aktifKullanici.kullaniciAdi)
            .collection('list')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final friends = snapshot.data!.docs;

          if (friends.isEmpty) {
            return const Center(
              child: Text(
                "Henüz arkadaşın yok...",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final data = friends[index].data() as Map<String, dynamic>;
              final arkadasAdi = data['arkadasAdi'] ?? "Bilinmeyen";
              final canSayisi = data['canSayisi'] ?? 0;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    arkadasAdi,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                  ),
                  subtitle: Text(
                    "Gönderilen Can: $canSayisi",
                    style: GoogleFonts.poppins(color: Colors.white60, fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.redAccent),
                    onPressed: () => canGonder(context, arkadasAdi), // 🔧 burada context gönderiyoruz
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
