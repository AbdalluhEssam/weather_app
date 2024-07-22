import 'package:dropdown_search/dropdown_search.dart';
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
        child: DropdownSearch<String>(
          validator: (value) {
            if (value?.isEmpty == true) {
              return "Not Data";
            }
            return null;
          },
          // filterFn: (city, filter) =>BlocProvider.of<GetWeatherCubit>(context).city.forEach((element) { }),

          popupProps: PopupProps.menu(
            showSearchBox: true,
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Search in City",
                style: TextStyle(fontSize: 20, color: Colors.orange),
              ),
            ),
            searchFieldProps: const TextFieldProps(
                decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: "Search",
              hintText: "Enter City Name",
              hintStyle: TextStyle(fontWeight: FontWeight.bold),
              contentPadding: EdgeInsets.all(20),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
            )),
            showSelectedItems: true,
            disabledItemFn: (String s) => s.startsWith('I'),
          ),

          items: BlocProvider.of<GetWeatherCubit>(context).city,
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
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
            ),
          ),

          onChanged: (value) {
            BlocProvider.of<GetWeatherCubit>(context)
                .getWeather(cityName: value!);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
