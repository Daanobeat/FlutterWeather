import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/Api/Api.dart';
import 'package:flutter_weather/Database/database.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import '../Helper/Extensions.dart';
import '../Model/WeatherResponse.dart';
import 'detail.dart';

class ListWidget extends StatefulWidget {
  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> with WidgetsBindingObserver {
  Api api = Api();
  Position _currentPosition;
  List<WeatherItem> data = [];

  @override
  void initState() {
    if(_currentPosition != null ){
      print("LAT: ${_currentPosition.latitude} LONG: ${_currentPosition.longitude}");
      _pullRefresh();
    }else{
      Geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
          .then((Position position) {
        print("LAT: ${position.latitude} LONG: ${position.longitude}");
        setState(() {
          _currentPosition = position;
        });
        _pullRefresh();
      }).catchError((e) {
        print(e);
      });
    }

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("Resumed_");
      _pullRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return _buildRow(data[index]);
          },
          itemCount: data.length,
        ),
        onRefresh: _pullRefresh);
  }

  Future<void> _pullRefresh() async {
    var loadedData = await api.fetchWeahter(http.Client(),_currentPosition.latitude,_currentPosition.longitude);
    deleteAll();
    insertWeatherItem(loadedData);
    getAllWeatherItems();
  }

  Widget _buildRow(WeatherItem data) {
    return Card(
      child: ListTile(
        leading: Image.network(
            BASE_ICON_URL + "${data.weather[0].icon}" + "@2x.png"),
        title: Text(
            "${data.dt.parseSecondsToDate()} ${data.dt.parseSecondsToTime()}"),
        subtitle: Text(data.main.temp.addUnit()),
        onTap: () {
          navigate(data);
        },
      ),
    );
  }

  insertWeatherItem(List<WeatherItem> items) async {
    final db = await DBProvider.db.database;
    var rows = "";
    items.forEach((element) async {
      rows+="(${element.dt},${element.main.temp},${element.main.pressure},${element.main.humidity},\'${element.weather[0].main}\',\'${element.weather[0].description}\',\'${element.weather[0].icon}\'),";
    });
    rows=rows.substring(0,rows.length-1);
    var res = await db.rawInsert(
        "INSERT INTO Weather(dt,temp,pressure,humidity,main,description,icon) VALUES $rows"
    );
    return res;
  }

  deleteAll() async {
    final db = await DBProvider.db.database;
    db.rawDelete("DELETE FROM Weather");
  }

  getAllWeatherItems() async {
    final db = await DBProvider.db.database;
    var res = await db.rawQuery("SELECT * FROM Weather");
    List<WeatherItem> items = [];
    res.forEach((element) {
      List<Weather> weatherList = [];
      weatherList.add(Weather(element.values.elementAt(4), element.values.elementAt(5), element.values.elementAt(6)));
      items.add(WeatherItem(
          element.values.elementAt(0),
          Main(element.values.elementAt(1),element.values.elementAt(2),element.values.elementAt(3)),
          weatherList));
    });

    setState(() {
      data = items;
    });
  }

  void navigate(WeatherItem data) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return DetailWidget(data);
    }));
  }
}

String BASE_ICON_URL = "http://openweathermap.org/img/wn/";
