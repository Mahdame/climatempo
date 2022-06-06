import 'dart:convert';
import 'dart:io';

import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geolocator/geolocator.dart';
import 'package:climatempo/model/weather_model.dart';
import 'package:climatempo/utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../model/weather_model.dart';

class Location {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  double? lat;
  double? lon;

  void _registerPlatformInstance() {
    if (Platform.isAndroid) {
      GeolocatorAndroid.registerWith();
    } else if (Platform.isIOS) {
      GeolocatorApple.registerWith();
    }
  }

  Future<WeatherModel> fetchCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return Future.error('Location services are disabled.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    lat = position.latitude;
    lon = position.longitude;

    var url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$kAppId';
    final response = await http.get(Uri.parse(url));

    return fetchData(response);
  }

  Future<WeatherModel> fetchData(Response response) async {
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather.');
    }
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    _registerPlatformInstance();

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return false;
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
  }
}
