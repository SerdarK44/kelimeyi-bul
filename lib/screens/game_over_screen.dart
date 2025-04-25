import 'package:flutter/material.dart';
import 'home_screen.dart';

class GameOverScreen extends StatelessWidget {
  final String hedefKelime;

  const GameOverScreen({super.key, required this.hedefKelime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kaybettin")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("😢 Doğru Kelime: $hedefKelime", style: TextStyle(fontSize: 22)),
              SizedBox(height: 20),
              Text("❤️ Canın 1 azaldı", style: TextStyle(fontSize: 18, color: Colors.red)),
              SizedBox(height: 30),
              ElevatedButton.icon(
                icon: Icon(Icons.home),
                label: Text("Ana Sayfaya Dön"),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
