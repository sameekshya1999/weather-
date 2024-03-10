import "package:flutter/material.dart";
import 'package:weather_app/forecast.dart';
import 'package:weather_app/weather_forecast_api.dart';

class WeatherForcastModel with ChangeNotifier {
  bool isRequestPending = false;
  bool isWeatherLoaded = false;
  bool isRequestError = false;

  String _city = "";
  List<Forcast> _dailyForecast = <Forcast>[];

  String get city => _city;
  List<Forcast> get dailyForecast => _dailyForecast;

  late WeatherApi weatherApi;

  WeatherForcastModel() {
    weatherApi = WeatherApi();
  }

  Future<void> requestForcast(String city) async {
    setRequestPendingState(true);
    this.isRequestError = false;
    try {
      // await Future.delayed(Duration(seconds: 1), () => {});
      _dailyForecast = await weatherApi.getWeather(city);
    } catch (e) {
      this.isRequestError = true;
    }

    this.isWeatherLoaded = true;
    setRequestPendingState(false);
    notifyListeners();
  }

  void setRequestPendingState(bool isPending) {
    this.isRequestPending = isPending;
    notifyListeners();
  }
}
