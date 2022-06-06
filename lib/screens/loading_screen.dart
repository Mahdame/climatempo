import 'package:climatempo/model/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:climatempo/services/location.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Location location = Location();
  late Future<WeatherModel> futureWeather;

  @override
  void initState() {
    super.initState();
    futureWeather = location.fetchCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Weather Data Example'),
        ),
        body: Center(
          child: FutureBuilder<WeatherModel>(
            future: futureWeather,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                    '${snapshot.data?.city}, ${snapshot.data?.temperature}, ${snapshot.data?.condition}');
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
