import 'package:intl/intl.dart'; // needed for using DateFormat class

class Forcast {
  final String dayAndHour;
  final String minTemp;
  final String maxTemp;
  final String humidity;
  final String description;
  final String iconURL;

  Forcast({
    required this.dayAndHour,
    required this.minTemp,
    required this.maxTemp,
    required this.humidity,
    required this.description,
    required this.iconURL,
  });

  static Forcast fromJson(dynamic json) {
    // get the local date and time from json
    var dateTime =
        DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: false);

    return Forcast(
      // get the dayAndHour in the format of "Monday, 9:00 AM"
      dayAndHour: DateFormat('EEEE, h:mm a').format(dateTime).toString(),
      minTemp: ((json['main']['temp_min'] - 273.15) * 9 / 5 + 32)
              .round()
              .toString() +
          "\u00B0F",
      maxTemp: ((json['main']['temp_max'] - 273.15) * 9 / 5 + 32)
              .round()
              .toString() +
          "\u00B0F",
      humidity: json['main']['humidity'].toString(),
      description: json['weather'][0]['description'].toString(),
      iconURL: "http://openweathermap.org/img/w/" +
          json['weather'][0]['icon'] +
          ".png",
    );
  }
}
