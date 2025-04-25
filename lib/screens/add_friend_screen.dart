import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../services/firebase_service.dart'; // service dosyasını import ediyoruz

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> arkadaslikIstegiGonder() async {
    final arkadasAdi = _controller.text.trim();

    if (arkadasAdi.isEmpty) {
      _showSnackBar("Kullanıcı adı boş olamaz!");
      return;
    }

    if (arkadasAdi == aktifKullanici.kullaniciAdi) {
      _showSnackBar("Kendini arkadaş olarak ekleyemezsin.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Kullanıcı var mı kontrol et
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(arkadasAdi)
          .get();

      if (!userDoc.exists) {
        _showSnackBar("Böyle bir kullanıcı bulunamadı.");
        setState(() => _isLoading = false);
        return;
      }

      // Daha önce istek gönderilmiş mi?
      final ref = FirebaseFirestore.instance
          .collection('friend_requests')
          .doc(arkadasAdi)
          .collection('list')
          .doc(aktifKullanici.kullaniciAdi);

      final existing = await ref.get();
      if (existing.exists) {
        _showSnackBar("Bu kullanıcıya zaten istek göndermişsin.");
      } else {
        await friendRequestGonder(arkadasAdi); // ✅ service dosyasından çağırıyoruz
        _showSnackBar("✅ İstek başarıyla gönderildi!");
        Navigator.pop(context); // geri dön
      }
    } catch (e) {
      _showSnackBar("Bir hata oluştu: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mesaj)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text("Arkadaş Ekle"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Kullanıcı adı",
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white24),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : arkadaslikIstegiGonder,
              icon: const Icon(Icons.send),
              label: const Text("İstek Gönder"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
