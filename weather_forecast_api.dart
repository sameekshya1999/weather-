import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:weather_app/forecast.dart';

class WeatherApi {
  static const endPointUrl = 'https://api.openweathermap.org/data/2.5';
  static const apiKey =
      "61f2c40da4ef24411b02a884d0307ab1"; // replace this by your own API key
  late http.Client httpClient;

  WeatherApi() {
    this.httpClient = new http.Client();
  }

  Future<List<Forcast>> getWeather(String city) async {
    var dailyList = <Forcast>[];

    final requestUrl = '$endPointUrl/forecast?q=$city&appid=$apiKey';
    print("${Uri.parse(Uri.encodeFull(requestUrl))}");

    final response =
        await this.httpClient.get(Uri.parse(Uri.encodeFull(requestUrl)));

    if (response.statusCode != 200) {
      throw Exception('error retrieving weather: ${response.statusCode}');
    }

    var items = jsonDecode(response.body)['list'];
    dailyList = items.map<Forcast>((item) => Forcast.fromJson(item)).toList();

    return dailyList;
  }
}
