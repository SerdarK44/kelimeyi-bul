class Arkadas {
  final String id;
  final String kullaniciAdi;
  int canSayisi;
  bool canGonderildi;

  Arkadas({
    required this.id,
    required this.kullaniciAdi,
    required this.canSayisi,
    this.canGonderildi = false,
  });
}
