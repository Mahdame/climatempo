class WeatherModel {
  final double? temperature;
  final String? condition;
  final String? city;
  WeatherModel({this.temperature, this.condition, this.city});

  factory WeatherModel.fromJson(Map<String?, dynamic> json) {
    return WeatherModel(
      temperature: json['main']['temp'],
      condition: json['weather'][0]['main'],
      city: json['name'],
    );
  }
}