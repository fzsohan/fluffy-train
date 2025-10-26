import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService();
  Weather? _weather;

  // Fetch weather for a default city or current location
  _fetchWeather() async {
    try {
      // Option 1: Fetch by current location
      final weatherData = await _weatherService.getWeatherByLocation();
      setState(() {
        _weather = weatherData;
      });
    } catch (e) {
      // Handle the error (e.g., show a SnackBar)
      print(e);
      // Fallback for demo: show weather for a default city
      _fetchDefaultCityWeather();
    }
  }

  _fetchDefaultCityWeather() async {
     try {
      final weatherData = await _weatherService.getWeather('London');
      setState(() {
        _weather = weatherData;
      });
    } catch (e) {
      print("Could not fetch weather for default city: $e");
    }
  }

  // Helper function to get weather animation/icon
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; // default

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchWeather,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // City Name
            Text(
              _weather?.cityName ?? "Loading city..",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 20),

            // **Weather Animation/Icon Placeholder**
            // In a real app, you would use a package like 'lottie' here
            // to display animated weather icons.
            Icon(
              Icons.wb_sunny,
              size: 100,
              color: Colors.amber,
            ),
            // Example Lottie Placeholder:
            // Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            const SizedBox(height: 20),
            
            // Temperature
            Text(
              '${_weather?.temperature.round()}°C',
              style: const TextStyle(fontSize: 64),
            ),

            // Weather Condition
            Text(
              _weather?.mainCondition ?? "",
              style: const TextStyle(fontSize: 24),
            ),

            // Error/Loading indicator
            if (_weather == null)
              const Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }
}