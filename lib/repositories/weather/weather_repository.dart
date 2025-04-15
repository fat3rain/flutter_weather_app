import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:group_notification_app/features/city_list/mapper/mapper_city.dart';
import 'package:group_notification_app/features/city_list/models/city.dart';
import 'package:translator/translator.dart';

class WeatherRepository {
  Future<City> getCity(String cityName) async {
    final translator = GoogleTranslator();
    cityName = (await translator.translate(cityName)).toString();
    final response = await Dio().get(
        'http://api.weatherapi.com/v1/current.json?key=c5ec03105ef2495483771937231011&aqi=no',
        queryParameters: {'q': cityName});
    debugPrint(response.toString());

    return await CityMapper.fromJson(response.data);
  }
}
