

import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/WeatherResponse.dart';

class Api {

  List<WeatherItem> parseCards(String responseBody) {
    final parsed = jsonDecode(responseBody)['list'].cast<
        Map<String, dynamic>>();
    print(parsed);
    return parsed.map<WeatherItem>((json) => WeatherItem.fromJson(json))
        .toList();
  }

  Future<List<WeatherItem>> fetchWeahter(http.Client client, double lat, double lon) async {
    String BASE_URL =
        'https://api.openweathermap.org/data/2.5/forecast?q=Hollabrunn&appid=943324b67600e3a04cbc0376e6fabc20&units=metric&lat=$lat&lon=$lon';
    print(BASE_URL);
    try {
      final response = await client.get(Uri.parse(BASE_URL));
      if (response.statusCode == 200) {
        return parseCards(response.body);
      } else {
        print("ERROR:");
        throw Exception("Error:Cards not loaded");
      }
    }catch(e){
      print(e);
    }
  }
}