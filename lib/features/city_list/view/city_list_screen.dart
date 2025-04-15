import 'package:flutter/material.dart';
import 'package:group_notification_app/features/city_list/models/city.dart';
import 'package:group_notification_app/features/city_list/storage/storage.dart';
import 'package:group_notification_app/features/city_list/widgets/city_tile.dart';
import 'package:group_notification_app/repositories/weather/weather_repository.dart';
import 'package:translator/translator.dart';

class CityListScreen extends StatefulWidget {
  const CityListScreen({super.key, required this.title});

  final String title;

  @override
  State<CityListScreen> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  late final TextEditingController _textEditingController;
  final List<City> cityList = [];
  final List<City> cityListFav = [];
  bool wasLoaded = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _loadFavCities();
  }

  Future<void> _loadFavCities() async {
    if (wasLoaded) return;

    final favoritesCitiesNames = storage.getCitiesNames();

    final repository = WeatherRepository();
    for (final favCity in favoritesCitiesNames) {
      cityListFav.add(await repository.getCity(favCity));
    }

    setState(() => wasLoaded = true);
  }

  void updateCity(City city) {
    int index = cityList.indexWhere((element) => element.name == city.name);
    if (index != -1) {
      cityList[index] = city;
    } else {
      index = cityListFav.indexWhere((element) => element.name == city.name);
      cityListFav[index] = city;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color.fromARGB(255, 252, 254, 243),
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: const BottomAppBar(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              textAlign: TextAlign.center,
              'Здесь могла быть ваша реклама',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w900),
            ),
          ),
          body: !wasLoaded
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(width: 2.0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              hintText: 'Погода в городе: ',
                              hintStyle: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            giveCity(context, _textEditingController.text);
                            _textEditingController.clear();
                          },
                          color: Colors.black,
                        ),
                      ],
                    ),
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverList.builder(
                            itemCount: cityListFav.length,
                            itemBuilder: (context, i) {
                              return CityTile(
                                addCityFav: () =>
                                    addCityFav(cityListFav[i], true),
                                city: cityListFav[i],
                                deleteCity: () =>
                                    deleteCity(cityListFav[i], true),
                                isFav: true,
                                updateCity: updateCity,
                              );
                            },
                          ),
                          const SliverToBoxAdapter(child: Divider()),
                          SliverList.builder(
                            itemCount: cityList.length,
                            itemBuilder: (context, i) {
                              return CityTile(
                                addCityFav: () =>
                                    addCityFav(cityList[i], false),
                                city: cityList[i],
                                deleteCity: () =>
                                    deleteCity(cityList[i], false),
                                isFav: false,
                                updateCity: updateCity,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> giveCity(BuildContext context, String enteredCity) async {
    final translator = GoogleTranslator();
    enteredCity = (await translator.translate(enteredCity, to: 'ru'))
        .toString()
        .toLowerCase();
    for (final city in [...cityList, ...cityListFav]) {
      if (city.name.toLowerCase() == enteredCity) return;
    }
    final repository = WeatherRepository();
    try {
      final city = await repository.getCity(enteredCity);
      setState(() => cityList.add(city));
    } catch (e) {
      // ignore: use_build_context_synchronously
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(
                  'Извините, город не найден',
                  textAlign: TextAlign.center,
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'ок',
                    ),
                  )
                ],
              ));
    }
  }

  void deleteCity(City city, bool isFav) {
    if (isFav) {
      setState(() {
        cityListFav.removeWhere((item) => item == city);
        storage.deleteCityName(city.name);
      });
    } else {
      setState(() {
        cityList.removeWhere((item) => item == city);
      });
    }
  }

  // Future<void> giveCityFav(City cityToAdd) async {
  //   final repository = WeatherRepository();
  //   for (final favCity in cityListFav) {
  //     await repository.getCity(favCity.toString());
  //   }

  //   setState(() => cityList.add(cityToAdd));
  // }

  void addCityFav(City city, bool isFav) {
    if (isFav) {
      setState(() {
        cityListFav.removeWhere((item) => item == city);
        cityList.add(city);
        storage.deleteCityName(city.name);
      });
    } else {
      setState(() {
        cityList.removeWhere((item) => item == city);
        cityListFav.add(city);
        storage.addCityName(city.name);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }
}
