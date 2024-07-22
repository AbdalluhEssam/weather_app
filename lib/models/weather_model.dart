class WeatherModel {
  final String? cityName;
  final DateTime? date;
  final String? image;
  final String? temp;
  final String? maxTemp;
  final String? minTemp;
  final String? weatherCondition;

  WeatherModel({required this.cityName,
    required this.date,
    required this.image,
    required this.temp,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCondition});


  factory WeatherModel.fromJson(json){
    return WeatherModel(
        cityName: json['location']['name'].toString(),
        date: DateTime.parse(json['current']['last_updated'].toString()),
        image: json['forecast']['forecastday'][0]['day']['condition']['icon'].toString(),
        temp: json['current']['temp_c'].toString(),
        maxTemp: json['forecast']['forecastday'][0]['day']['maxtemp_c'].toString(),
        minTemp: json['forecast']['forecastday'][0]['day']['mintemp_c'].toString(),
        weatherCondition: json['forecast']['forecastday'][0]['day']['condition']['text'].toString(),
    );
  }
}
