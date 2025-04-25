# 🎯 Kelimeyi Bul - Mobil Kelime Oyunu

Kelimeyi Bul, Wordle tarzı ancak daha gelişmiş özelliklere sahip Türkçe bir kelime oyunudur. Oyuncular zorluk seviyesini seçerek rastgele gelen kelimeyi sınırlı sayıda tahminle çözmeye çalışır. Firebase altyapısıyla canlı skor takibi, arkadaşlık sistemi ve can gönderme gibi sosyal özellikler içerir.

---

## 📱 Özellikler

- ✅ **Zorluk Seviyeleri:**  
  - Kolay: 5 harfli kelimeler  
  - Orta: 6 harfli kelimeler  
  - Zor: 7 harfli kelimeler  

- 🧠 **Oyun Mekaniği:**  
  - Her tahminde renklerle doğru harf/konum bildirimi  
  - Aynı kelimeyi tekrar tahmin engeli  
  - 6 tahmin hakkı sınırı

- ❤️ **Can Sistemi:**  
  - Oyuncular 5 canla başlar  
  - 1 saatte 1 can otomatik olarak yenilenir  
  - Arkadaşlardan can isteyip alabilir

- 👫 **Arkadaşlık Sistemi:**  
  - Kullanıcı adıyla arkadaş ekleme  
  - Can gönderme, alma ve arkadaşlık istekleri  
  - Gönderilen can miktarı görüntüleme  
  - Gelen istek sayısı rozet olarak görünür

- 📈 **Liderlik Tablosu:**  
  - Oyuncuların toplam skorlarına göre canlı sıralama  
  - Firebase Firestore üzerinden anlık güncellenir

- 📦 **Diğer Özellikler:**  
  - Firebase Firestore entegrasyonu  
  - Shared Preferences ile kullanıcı adı saklama  
  - Responsive ve sade UI tasarımı  
  - Google Fonts (Poppins) kullanımı

---

## 🚀 Kurulum

### Flutter Ortamında:

```bash
git clone https://github.com/SerdarK44/kelimeyi-bul.git
cd kelimeyi-bul
flutter pub get
flutter run
```

## Android APK Oluşturma:
```
flutter build apk --release
```
APK dosyası şu klasörde oluşur:
build/app/outputs/flutter-apk/app-release.apk

### 📁 Proje Yapısı
lib/
├── screens/
│   ├── home_screen.dart
│   ├── game_screen.dart
│   ├── result_screen.dart
│   ├── game_over_screen.dart
│   ├── profile_screen.dart
│   ├── friends_screen.dart
│   └── add_friend_screen.dart
├── services/
│   └── firebase_service.dart
├── models/
│   └── score_model.dart
├── utils/
│   └── score_calculator.dart
├── main.dart


### 📊 Sürüm Bilgisi
v1.0 – 25 Nisan 2025
Tüm temel oyun mekaniği tamamlandı

Firebase ile tam entegre skor, kullanıcı, arkadaş, can sistemleri

Android APK başarıyla üretildi ve test edildi

Uygulama mobil cihazlarda sorunsuz çalışmaktadır

👨‍💻 Geliştirici
Serdar K.
GitHub

⚖️ Lisans
MIT Lisansı altında yayınlanmıştır. Daha fazla bilgi için LICENSE dosyasını inceleyin.
