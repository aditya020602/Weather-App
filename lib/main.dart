import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var sky;
  var humidity;
  var country;
  Position currentposition;
  var cityname;
  var temp;
  var feelslike;
  var pressure;
  var url = 'http://api.openweathermap.org/data/2.5/weather?q=London&appid=';
  Future getData() async {
    cityname = 'Mumbai';

    url = 'http://api.openweathermap.org/data/2.5/weather?q=Mumbai&appid=';

    var response = await http.get(url);

    var data = jsonDecode(response.body) as Map<String, dynamic>;
    print(data);
    print(data['weather'][0]['main']);
    setState(() {
      temp = (data['main']['temp'] - 273.15).toStringAsFixed(2);
      feelslike = (data['main']['feels_like'] - 273.15).toStringAsFixed(2);
      pressure = data['main']['pressure'] * 100;
      sky = data['weather'][0]['description'];
      humidity = data['main']['humidity'];
      country = data['sys']['country'];
      print('set state');
    });
  }

  Future cityData() async {
    var response = await http.get(url);

    var data = jsonDecode(response.body) as Map<String, dynamic>;
    print(data);
    try {
      print(data['weather'][0]['main']);
      setState(() {
        temp = (data['main']['temp'] - 273.15).toStringAsFixed(2);
        feelslike = (data['main']['feels_like'] - 273.15).toStringAsFixed(2);
        pressure = (data['main']['pressure']) * 100;
        sky = data['weather'][0]['description'];
        humidity = data['main']['humidity'];
        country = data['sys']['country'];
        print('set state');
      });
    } catch (error) {
      setState(() {
        temp = 'INVALID';
        feelslike = 'INVALID';
        pressure = 'INVALID';
        country = 'INVALID';
        humidity = 'INVALID';
      });
    }
  }

  Future locationdata() async {
    var lat = currentposition.latitude;
    var long = currentposition.longitude;
    url =
        'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=';
    var response = await http.get(url);
    var data = jsonDecode(response.body) as Map<String, dynamic>;
    setState(() {
      temp = data['main']['temp'];
      feelslike = data['main']['feels_like'];
      pressure = (data['main']['pressure']) * 100;
      sky = data['weather'][0]['description'];
      humidity = data['main']['humidity'];
      country = data['sys']['country'];
    });
  }

  @override
  void initState() {
    super.initState();

    getData();
    print('initstate');
  }

  final city = TextEditingController();
  void citynamechanger() {
    setState(() {
      cityname = city.text;
      url = 'http://api.openweathermap.org/data/2.5/weather?q=$cityname&appid=';
      cityData();
    });
  }

  geolocation() async {
    var position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    setState(() {
      currentposition = position;
      cityname = 'Current Location';
      print(currentposition);
      locationdata();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    print('hello');
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Color.fromRGBO(252, 237, 237, 1),
      appBar: AppBar(
        title: Text(
          'Weather',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(255, 0, 255, 1),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: TextField(
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Search',
                ),
                controller: city,
              ),
            ),
            Column(
              children: [
                RaisedButton(
                  child: Text('OK'),
                  onPressed: citynamechanger,
                ),
                FittedBox(
                  child: Text(
                    '$cityname'.toUpperCase(),
                    style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                  ),
                ),
                FittedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nation: $country',
                          style: TextStyle(fontSize: 35, color: Colors.black)),
                      Text(
                        'Temperature: $temp' + '\u2103',
                        style: TextStyle(fontSize: 35, color: Colors.black),
                      ),
                      Text(
                        'Feels-like: $feelslike' + '\u2103',
                        style: TextStyle(fontSize: 35, color: Colors.black),
                      ),
                      Text(
                        'Pressure:$pressure Pa',
                        style: TextStyle(fontSize: 35, color: Colors.black),
                      ),
                      Text('Humidity: $humidity %',
                          style: TextStyle(fontSize: 35, color: Colors.black)),
                      Text('sky : $sky',
                          style: TextStyle(fontSize: 35, color: Colors.black)),
                      RaisedButton(
                        child: Text('MY LOCATION DATA'),
                        onPressed: geolocation,
                        color: Colors.white,
                        elevation: 10,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
