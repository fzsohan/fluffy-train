import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/weather.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  // Use a secure method like flutter_dotenv for the key in a real app
  final String apiKey = '6bed0f8964ed563e06a370d3031923eb'; 

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(Uri.parse('$_baseUrl?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    // 1. Get location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // 2. Fetch the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // This part requires a separate Geocoding API to convert lat/long to city name,
    // but for simplicity, we'll use the current coordinates to fetch weather directly.
    // A complete solution would use 'geocoding' package to get the city name.
    final response = await http.get(Uri.parse(
        '$_baseUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric'));
    
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body)).cityName;
    } else {
      throw Exception('Failed to determine city from location');
    }
  }

  // To fetch weather by current location
  Future<Weather> getWeatherByLocation() async {
    String cityName = await getCurrentCity();
    return getWeather(cityName); // Re-uses the primary fetch method
  }
}