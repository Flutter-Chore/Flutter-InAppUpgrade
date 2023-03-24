
enum AppMarket {
  official("official"),
  googlePlay("google_play"),
  cool("cool"),
  tencent("tencent"),
  baidu("baidu"),
  qihoo("360"),
  wandoujia("wandoujia");

  final String name;

  const AppMarket(this.name);

  static AppMarket init(String market) {
    return AppMarket.values.firstWhere((element) => element.name == market, orElse: () => AppMarket.official);
  }
}