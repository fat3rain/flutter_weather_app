class City {
  final String name;
  final String country;
  final DateTime localtime;
  final double currentTempr;
  final String condition;
  final String iconUrl;

  const City({
    required this.name,
    required this.country,
    required this.localtime,
    required this.currentTempr,
    required this.condition,
    required this.iconUrl,
  });
}
