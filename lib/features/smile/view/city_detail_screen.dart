import 'package:flutter/material.dart';
import 'package:group_notification_app/features/city_list/city_list.dart';
import 'package:group_notification_app/features/city_list/models/city.dart';
import 'package:group_notification_app/repositories/weather/weather_repository.dart';
import 'package:translator/translator.dart';

class CityScreen extends StatefulWidget {
  final City city;
  final Function(City) updateCity;

  const CityScreen({
    super.key,
    required this.city,
    required this.updateCity,
  });

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final translator = GoogleTranslator();
  late City city;
  bool wasLoaded = false;

  @override
  void initState() {
    super.initState();
    city = widget.city;
  }

  Future<String> getTranslation() async {
    return (await translator.translate(city.condition, to: 'ru')).toString();
  }

  Future<String> getInfo() async {
    if (!wasLoaded) {
      final repository = WeatherRepository();
      final info = await repository.getCity(city.name);
      widget.updateCity(info);
      setState(() {
        city = info;
        wasLoaded = true;
      });
    }
    return await getTranslation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(city.name),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w900, fontSize: 12),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(MaterialPageRoute(
                builder: (context) => const CityListScreen(title: ''))),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: getInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Температура: ${city.currentTempr.toString()}°C',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              snapshot.data.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Время: ${(city.localtime.toString()).substring(11, 16)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Страна: ${city.country}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // время и страна

                    const SizedBox(height: 12),
                    getIcon(),
                  ],
                );
              }
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget getIcon() {
    switch (city.condition) {
      case 'Overcast':
        return Image.asset(
          'assets/cat_icons/overcast.png',
          height: 120,
          width: 120,
        );
      case 'Mist':
        return Image.asset(
          'assets/cat_icons/mist.png',
          height: 120,
          width: 120,
        );
      case 'Light snow showers':
        return Image.asset(
          'assets/cat_icons/light_snow_showers.png',
          height: 120,
          width: 120,
        );
      
      case 'Light snow':
      case 'Heavy snow':
        return Image.asset(
          'assets/cat_icons/snowy.png',
          height: 120,
          width: 120,
        );
      case 'Partly cloudy':
        return Image.asset(
          'assets/cat_icons/partly_cloudy.png',
          height: 120,
          width: 120,
        );
      case 'Clear':
        return Image.asset(
          'assets/cat_icons/clear.jpg',
          height: 120,
          width: 120,
        );

      case 'Light drizzle':
      case 'Moderate rain':
      case 'Light rain':
        return Image.asset(
          'assets/cat_icons/rainy.png',
          height: 120,
          width: 120,
        );

      case 'Sunny':
        return Image.asset(
          'assets/cat_icons/sunny.png',
          height: 120,
          width: 120,
        );

      default:
        return Image.network(
          'http:${city.iconUrl}',
          height: 120,
          width: 120,
        );
    }
  }
}
