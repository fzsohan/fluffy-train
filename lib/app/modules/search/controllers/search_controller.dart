import 'package:get/get.dart';

class WeatherController extends GetxController {
  var cityName = ''.obs;
  var weatherDescription = 'No weather data'.obs;
  var temperature = 0.0.obs;
  var isLoading = false.obs;

  // Simulate API call for weather data
  Future<void> fetchWeather(String city) async {
    isLoading.value = true;
    cityName.value = city; // Update city name immediately

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    // In a real app, you would make an actual API call here
    // For demonstration, we'll use dummy data
    if (city.toLowerCase() == 'london') {
      weatherDescription.value = 'Cloudy';
      temperature.value = 15.5;
    } else if (city.toLowerCase() == 'new york') {
      weatherDescription.value = 'Sunny';
      temperature.value = 22.1;
    } else {
      weatherDescription.value = 'City not found';
      temperature.value = 0.0;
    }

    isLoading.value = false;
  }
}