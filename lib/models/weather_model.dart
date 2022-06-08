import 'package:climatempo/services/location.dart';
import 'package:geolocator/geolocator.dart';

import '../utilities/networking.dart';

const kAppId = 'e561e5d30307a21b9369d833da6322cc';
const kOpenWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {

  Future<dynamic> getCityWeather(String cityName) async {
    var url = '$kOpenWeatherMapURL?q=$cityName&appid=$kAppId&units=metric';
    NetworkHelper networkHelper = NetworkHelper(url);
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    final hasPermission = await location.handlePermission();

    if (!hasPermission) {
      return Future.error('Location services are disabled.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    NetworkHelper networkHelper = NetworkHelper(
        '$kOpenWeatherMapURL?lat=${position.latitude}&lon=${position.longitude}&appid=$kAppId&units=metric');

    var weatherData = await networkHelper.getData();

    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'É hora de 🍦';
    } else if (temp > 20) {
      return 'Mais um dia 🌞';
    } else if (temp < 10) {
      return 'Hora de se 🧣agasalhar🧤';
    } else {
      return 'Leve um ☂️ talvez precise';
    }
  }
}
