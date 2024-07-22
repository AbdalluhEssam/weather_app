import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubit/get_weather_cubit/get_weather_cubit.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search a City"),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(20),
        child: TextFormField(
          onFieldSubmitted: (value) async {
            BlocProvider.of<GetWeatherCubit>(context).getWeather(cityName: value);
            Navigator.pop(context);
            // log(weatherModel!.cityName.toString());
          },
          decoration: const InputDecoration(
              labelText: "Search",
              hintText: "Enter City Name",
              hintStyle: TextStyle(fontWeight: FontWeight.bold),
              contentPadding: EdgeInsets.all(20),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              suffixIcon: Icon(Icons.search)),
        ),
      ),
    );
  }
}
