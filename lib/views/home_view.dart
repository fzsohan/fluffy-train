import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weather_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  
  // Initialize and register the controller globally
  final WeatherController weatherController = Get.put(WeatherController());
  final TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App ☀️'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Search Input
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: 'Enter City Name',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      weatherController.fetchWeather(cityController.text);
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (value) => weatherController.fetchWeather(value),
              ),
              const SizedBox(height: 30),
              
              // **Obx (Observer) Widget** to react to controller state changes
              Obx(() {
                if (weatherController.isLoading.value) {
                  return const CircularProgressIndicator();
                }
                
                if (weatherController.errorMessage.isNotEmpty) {
                  return Text(
                    'Error: ${weatherController.errorMessage.value}',
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  );
                }

                final weather = weatherController.weatherData.value;
                if (weather == null) {
                  return const Text(
                    'Search for a city to get the weather!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  );
                }

                //  - optional visual aid

                return Column(
                  children: [
                    Text(
                      weather.cityName,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${weather.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(fontSize: 64, color: Colors.blue),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      weather.description.toUpperCase(),
                      style: const TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
