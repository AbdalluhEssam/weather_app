import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  // https://api.weatherapi.com/v1/forecast.json?key=b14fdaf74fab480d856232641241607&q=London&days=6&aqi=yes&alerts=yes#
  final Dio dio;

  WeatherService(this.dio);

  late WeatherModel weatherModel;
  final String baseUrl = "https://api.weatherapi.com/v1";
  final String apiKey = "b14fdaf74fab480d856232641241607";

  Future<WeatherModel> getCurrentWeather({required String cityName}) async {
    try {
      await dio
          .get(
              "$baseUrl/forecast.json?key=$apiKey&q=$cityName&days=1&aqi=yes&alerts=yes")
          .then((value) {
        weatherModel = WeatherModel.fromJson(value.data);
      });
      return weatherModel;
    } on DioException catch (e) {
      log(e.response.toString());
      final String errMessage = e.response?.data['error']['message'] ??
          "oops there was an error , try later";
      throw Exception(errMessage);
    } catch (e) {
      log(e.toString());
      throw Exception("oops there was an error , try later".toString());
    }
  }
}
