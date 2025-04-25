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
