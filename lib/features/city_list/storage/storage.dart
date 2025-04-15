import 'package:shared_preferences/shared_preferences.dart';

final Storage storage = Storage();

class Storage {
  late final SharedPreferences sharedPreferences;

  Storage();

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  List<String> getCitiesNames() {
    return sharedPreferences.getStringList('cities') ?? [];
  }

  void deleteCityName(String cityName) {
    var newCityNames = (sharedPreferences.getStringList('cities') ?? [])
      ..removeWhere((city) => cityName == city);
    sharedPreferences.setStringList('cities', newCityNames);
  }

  void addCityName(String cityName) {
    var newCityNames = (sharedPreferences.getStringList('cities') ?? []);
    if (!newCityNames.contains(cityName)) {
      newCityNames.add(cityName);
    }
    sharedPreferences.setStringList('cities', newCityNames);
  }
}
