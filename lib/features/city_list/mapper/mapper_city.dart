
import 'package:group_notification_app/features/city_list/models/city.dart';
import 'package:intl/intl.dart';
import 'package:translator/translator.dart';

class CityMapper {
  static Future<City> fromJson(Map<String, dynamic> json) async {
    final translator = GoogleTranslator();
    
    return City(
      name: (await translator.translate(json["location"]["name"], to: 'ru'))
          .toString(),
      country:
          (await translator.translate(json["location"]["country"], to: 'ru'))
              .toString(),
      localtime:
          DateFormat('yyyy-MM-dd HH:mm').parse(json["location"]["localtime"]),
      currentTempr: (json["current"]["temp_c"]),
      condition: (json["current"]["condition"]["text"]).toString(),
      iconUrl: json["current"]["condition"]["icon"],
    );
  }
}

// void main() async {
//   final translator = GoogleTranslator();

//   final input = "Здравствуйте. Ты в порядке?";

//   translator.translate(input, from: 'ru', to: 'en').then(print);
//   // prints Hello. Are you okay?
  
//   var translation = await translator.translate("Dart is very cool!", to: 'pl');
//   print(translation);
//   // prints Dart jest bardzo fajny!

//   print(await "example".translate(to: 'pt'));
//   // prints exemplo
// }