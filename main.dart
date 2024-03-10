import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:weather_app/weather_forecast_model.dart';

void main() => runApp(
      ChangeNotifierProvider<WeatherForcastModel>(
        create: (_) => WeatherForcastModel(),
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Weather App",
      home: Scaffold(
        body: SafeArea(
          child: WeatherViewer(),
        ),
      ),
    );
  }
}

class WeatherViewer extends StatefulWidget {
  const WeatherViewer({Key? key}) : super(key: key);

  @override
  _WeatherViewerState createState() => _WeatherViewerState();
}

class _WeatherViewerState extends State<WeatherViewer> {
  String cityName = '';

  void _saveCity(String input) {
    setState(() {
      cityName = input;
    });
  }

  void _queryForecast() {
    Provider.of<WeatherForcastModel>(context, listen: false)
        .requestForcast(cityName);
  }

  Widget _cityInputAndButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            //width: 300,
            margin: EdgeInsets.all(5),

            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter city'),
              keyboardType: TextInputType.streetAddress,
              onChanged: _saveCity,
              onSubmitted: _saveCity,
            ),
          ),
          flex: 3,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(5),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton(
                  child: Text(
                    'Fetch Forecast',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _queryForecast,
                  //style: ButtonStyle(
                  //    backgroundColor: MaterialStateProperty.all(Colors.blue)),
                ),
              ],
            ),
          ),
          flex: 1,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherForcastModel>(
      builder: (context, model, child) => Container(
        child: Column(
          children: <Widget>[
            _cityInputAndButton(),
            model.isRequestPending
                ? buildBusyIndicator()
                : model.isRequestError
                    ? Center(
                        child: Text(
                          'Ooops...something went wrong',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          // shrinkWrap: true,
                          padding: EdgeInsets.all(5),
                          itemCount: model.dailyForecast.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                leading: Image.network(
                                    model.dailyForecast[index].iconURL),
                                title: Text(
                                    "${model.dailyForecast[index].dayAndHour} " +
                                        "${model.dailyForecast[index].description}"),
                                subtitle: Text(
                                  "Low: " +
                                      "${model.dailyForecast[index].minTemp} " +
                                      "High: " +
                                      "${model.dailyForecast[index].maxTemp} " +
                                      "Humidity: " +
                                      "${model.dailyForecast[index].humidity}",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.blue),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

Widget buildBusyIndicator() {
  return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    CircularProgressIndicator(),
    SizedBox(
      height: 20,
    ),
    Text('Please Wait...',
        style: TextStyle(
            fontSize: 18, color: Colors.black, fontWeight: FontWeight.w300))
  ]);
}
