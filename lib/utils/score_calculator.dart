double hesaplaPuan({
  required String zorluk,
  required int tahminSayisi,
  required int sureSaniye,
}) {
  int maxPuan = switch (zorluk) {
    "kolay" => 100,
    "orta" => 125,
    "zor" => 150,
    _ => 100
  };

  double tahminKatsayi = switch (tahminSayisi) {
    1 => 0.6,
    2 => 0.5,
    3 => 0.4,
    4 => 0.3,
    5 => 0.2,
    6 => 0.1,
    _ => 0.05
  };

  double sureKatsayi = (0.4 - (sureSaniye * 0.01)).clamp(0.05, 0.4);

  return maxPuan * (tahminKatsayi + sureKatsayi);
}
