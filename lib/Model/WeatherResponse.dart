import 'package:dataclass/dataclass.dart';


class Main {
  num temp;
  num pressure;
  num humidity;

  Main(this.temp, this.pressure, this.humidity);

  factory Main.fromJson(Map<String,dynamic> json){
    return Main(
        json['temp'],
        json['pressure'],
        json['humidty']
    );
  }
}

class Weather{
  final String main;
  final String description;
  final String icon;

  Weather(this.main, this.description, this.icon);

  factory Weather.fromJson(Map<String, dynamic> json){
    return Weather(
        json['main'],
        json['description'],
        json['icon']
    );
  }
}

class WeatherItem {
  final int dt;
  final Main main;
  final List<Weather> weather;


  WeatherItem(this.dt, this.main, this.weather);


  factory WeatherItem.fromJson(Map<String, dynamic> json) {
    var weather = json['weather'] as List;
    List<Weather> weatherList = weather.map((e) => Weather.fromJson(e)).toList();
    return WeatherItem(
        json['dt'],
        Main.fromJson(json['main']),
        weatherList
    );
    // json['main']);
  }

  Map<String, dynamic> toMap() => {
    "dt": dt,
    "temp": main.temp,
    "pressure": main.pressure,
    "humidity": main.humidity,
    "main": weather[0].main,
    "description": weather[0].description,
    "icon": weather[0].icon
  };
}