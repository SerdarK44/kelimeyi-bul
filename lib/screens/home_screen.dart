import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'game_screen.dart';
import 'profile_screen.dart';
import 'leaderboard_screen.dart';
import '../main.dart';
import 'friends_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Kelime Oyunu',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(),
            const SizedBox(height: 32),
            _buildModeButton(context, 'Kolay Mod', 'kolay', Colors.greenAccent),
            const SizedBox(height: 16),
            _buildModeButton(context, 'Orta Mod', 'orta', Colors.amberAccent),
            const SizedBox(height: 16),
            _buildModeButton(context, 'Zor Mod', 'zor', Colors.redAccent),
            const SizedBox(height: 32),
            _buildMenuButton(
              context,
              title: '👤 Profil',
              icon: Icons.person,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            ),
            const SizedBox(height: 16),
            _buildMenuButton(
              context,
              title: '📊 Liderlik Tablosu',
              icon: Icons.leaderboard,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen())),
            ),
            const SizedBox(height: 16),
            _buildMenuButton(
              context,
              title: '👥 Arkadaşlarım',
              icon: Icons.group,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FriendsScreen())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '👤 ${aktifKullanici.kullaniciAdi.isEmpty ? 'Misafir' : aktifKullanici.kullaniciAdi}',
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            const Icon(Icons.favorite, color: Colors.redAccent),
            const SizedBox(width: 6),
            Text(
              '${aktifKullanici.canSayisi}',
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeButton(BuildContext context, String title, String difficulty, Color color) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GameScreen(difficulty: difficulty)),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.8),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        elevation: 2,
      ),
      child: Text(title),
    );
  }

  Widget _buildMenuButton(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size(double.infinity, 52),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(
        title,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
