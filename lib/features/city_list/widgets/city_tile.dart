import 'package:flutter/material.dart';

import 'package:group_notification_app/features/city_list/models/city.dart';
import 'package:group_notification_app/features/smile/view/city_detail_screen.dart';

class CityTile extends StatelessWidget {
  const CityTile({
    super.key,
    required this.city,
    required this.deleteCity,
    required this.addCityFav,
    required this.updateCity,
    required this.isFav,
  });

  final City city;
  final VoidCallback deleteCity;
  final VoidCallback addCityFav;
  final Function(City) updateCity;
  final bool isFav;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      // leading: ,
      leading:
          // getIcon(),
          Image.network(
        'http:${city.iconUrl}',
      ),

      title: Text(city.name, style: theme.textTheme.bodyMedium),
      subtitle: Text(
        '${city.currentTempr}°C',
        style: const TextStyle(fontSize: 15),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: addCityFav,
            color: Colors.red,
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
          ),
          IconButton(
            onPressed: deleteCity,
            icon: const Icon(Icons.close, color: Colors.black),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CityScreen(
              city: city,
              updateCity: updateCity,
            ),
          ),
        );
      },
    );
  }

  Widget getIcon() {
    switch (city.condition) {
      case 'Overcast':
        return Image.asset('assets/cat_icons/overcast.png');
      case 'Mist':
        return Image.asset('assets/cat_icons/mist.png');
      case 'Clear':
        return Image.asset('assets/cat_icons/clear.jpg');
      case 'Heavy snow':
        return Image.asset('assets/cat_icons/snowy.png');
      case 'Partly cloudy':
        return Image.asset('assets/cat_icons/partly_cloudy.png');
      case 'Light drizzle':
      case 'Moderate rain':
      case 'Light rain':
        return Image.asset('assets/cat_icons/rainy.png');
      case 'Sunny':
        return Image.asset('assets/cat_icons/sunny.png');

      default:
        return Image.network('http:${city.iconUrl}');
    }
  }
}
// Heavy snow Overcast Clear Sunny Light drizzle Moderate rain
// FloatingActionButton(onPressed: cityList.removeAt(0),);