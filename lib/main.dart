import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubit/get_weather_cubit/get_weather_cubit.dart';
import 'package:weather_app/cubit/get_weather_cubit/get_weather_states.dart';
import 'package:weather_app/views/home_view.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetWeatherCubit(),
      child: Builder(builder: (context) {
        return BlocBuilder<GetWeatherCubit, WeatherState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const HomeView(),
              theme: ThemeData(
                // backgroundColor: ,
                useMaterial3: false,
                appBarTheme: const AppBarTheme(elevation: 0),
                primarySwatch: getThemeColor(
                  BlocProvider
                      .of<GetWeatherCubit>(context)
                      .weatherModel
                      ?.weatherCondition,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

MaterialColor getThemeColor(String? condition) {
  if (condition == null) {
    return Colors.blue;
  }
  switch (condition) {
    case "Sunny":
      return Colors.orange;
    case "Partly cloudy":
      return Colors.blueGrey;
    case "Cloudy":
      return Colors.blue;
    case "Overcast":
      return Colors.grey;
    case "Mist":
      return Colors.lightBlue;
    case "Patchy rain possible":
      return Colors.lightBlue;
    case "Patchy snow possible":
      return Colors.cyan;
    case "Patchy sleet possible":
      return Colors.lightBlue;
    case "Patchy freezing drizzle possible":
      return Colors.cyan;
    case "Thundery outbreaks possible":
      return Colors.deepPurple;
    case "Blowing snow":
      return Colors.grey;
    case "Blizzard":
      return Colors.grey;
    case "Fog":
      return Colors.grey;
    case "Freezing fog":
      return Colors.cyan;
    case "Patchy light drizzle":
      return Colors.lightBlue;
    case "Light drizzle":
      return Colors.lightBlue;
    case "Freezing drizzle":
      return Colors.cyan;
    case "Heavy freezing drizzle":
      return Colors.cyan;
    case "Patchy light rain":
      return Colors.lightBlue;
    case "Light rain":
      return Colors.blue;
    case "Moderate rain at times":
      return Colors.amber;
    case "Moderate rain":
      return Colors.amber;
    case "Heavy rain at times":
      return Colors.indigo;
    case "Heavy rain":
      return Colors.indigo;
    case "Light freezing rain":
      return Colors.cyan;
    case "Moderate or heavy freezing rain":
      return Colors.cyan;
    case "Light sleet":
      return Colors.lightBlue;
    case "Moderate or heavy sleet":
      return Colors.lightBlue;
    case "Patchy light snow":
      return Colors.grey;
    case "Light snow":
      return Colors.grey;
    case "Patchy moderate snow":
      return Colors.grey;
    case "Moderate snow":
      return Colors.grey;
    case "Patchy heavy snow":
      return Colors.grey;
    case "Heavy snow":
      return Colors.grey;
    case "Ice pellets":
      return Colors.cyan;
    case "Light rain shower":
      return Colors.lightBlue;
    case "Moderate or heavy rain shower":
      return Colors.blue;
    case "Torrential rain shower":
      return Colors.indigo;
    case "Light sleet showers":
      return Colors.lightBlue;
    case "Moderate or heavy sleet showers":
      return Colors.blueGrey;
    case "Light snow showers":
      return Colors.grey;
    case "Moderate or heavy snow showers":
      return Colors.grey;
    case "Light showers of ice pellets":
      return Colors.cyan;
    case "Moderate or heavy showers of ice pellets":
      return Colors.cyan;
    case "Patchy light rain with thunder":
      return Colors.deepPurple;
    case "Moderate or heavy rain with thunder":
      return Colors.deepPurple;
    case "Patchy light snow with thunder":
      return Colors.grey;
    case "Moderate or heavy snow with thunder":
      return Colors.grey;
    default:
      return Colors.grey; // Default color if condition doesn't match
  }
}
