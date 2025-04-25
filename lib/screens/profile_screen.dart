import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'friend_requests_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String canDolumSuresiHesapla() {
    final simdi = DateTime.now();
    final sonrakiDolum = aktifKullanici.lastLifeRefill.add(const Duration(hours: 1));
    final fark = sonrakiDolum.difference(simdi);

    if (fark.isNegative) {
      return "Can yenilendi!";
    } else {
      final dakika = fark.inMinutes.remainder(60);
      final saniye = fark.inSeconds.remainder(60);
      return "$dakika dk $saniye sn kaldı";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text('Profilim'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('leaderboard').doc(aktifKullanici.kullaniciAdi).snapshots(),
        builder: (context, skorSnapshot) {
          final toplamSkor = skorSnapshot.data?.get('toplamSkor') ?? 0;

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        aktifKullanici.kullaniciAdi.isNotEmpty ? aktifKullanici.kullaniciAdi : "Misafir",
                        style: GoogleFonts.poppins(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "❤️ Can: ${aktifKullanici.canSayisi}",
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "⏳ Sonraki can dolum: ${canDolumSuresiHesapla()}",
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white54),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "🏆 Toplam Skor: $toplamSkor",
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.amberAccent),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('friend_requests')
                      .doc(aktifKullanici.kullaniciAdi)
                      .collection('list')
                      .snapshots(),
                  builder: (context, snapshot) {
                    final istekSayisi = snapshot.data?.docs.length ?? 0;

                    return Card(
                      color: Colors.white10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: const Icon(Icons.group, color: Colors.white),
                        title: Text(
                          "Gelen Arkadaşlık İstekleri",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (istekSayisi > 0)
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  "$istekSayisi",
                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const FriendRequestsScreen()),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}