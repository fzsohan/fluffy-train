import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart'; // Adjust path

class WeatherSearchScreen extends GetView<WeatherController> {
  final TextEditingController _searchController = TextEditingController();

  WeatherSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter City Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                controller.fetchWeather(_searchController.text);
              },
              child: Text('Search Weather'),
            ),
            SizedBox(height: 32),
            Obx(() {
              if (controller.isLoading.value) {
                return CircularProgressIndicator();
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'City: ${controller.cityName.value}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Description: ${controller.weatherDescription.value}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Temperature: ${controller.temperature.value.toStringAsFixed(1)}°C',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}