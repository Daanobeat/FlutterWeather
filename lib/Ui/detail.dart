import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/Ui/table.dart';

import '../Helper/Extensions.dart';
import '../Model/WeatherResponse.dart';

class DetailWidget extends StatelessWidget {
  final WeatherItem item;

  DetailWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Details")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TableDetail("Datum", item.dt.parseSecondsToDate()),
          TableDetail("Temperatur", item.main.temp.addUnit()),
          TableDetail("Feuchtigkeit", "32%"),
          TableDetail("Luftdruck", item.main.pressure.toString()),
          TableDetail("Icon Code", item.weather[0].icon),
          TableDetail("Vorhersage", item.weather[0].main),
          TableDetail("Beschreibung", item.weather[0].description),
        ],
      ),
    );
  }
}