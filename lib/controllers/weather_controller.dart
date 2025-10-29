import 'package:get/get.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherController extends GetxController {
  // Observable variables for state management
  var isLoading = true.obs;
  var weatherData = Rxn<WeatherModel>(); // Rxn is for nullable observables
  var errorMessage = ''.obs;
  var city = 'London'.obs; // Default city

  final WeatherService _weatherService = WeatherService();

  @override
  void onInit() {
    fetchWeather(); // Fetch initial weather when the controller is created
    super.onInit();
  }

  void fetchWeather([String? newCity]) async {
    if (newCity != null && newCity.isNotEmpty) {
      city.value = newCity;
    }

    try {
      isLoading.value = true;
      errorMessage.value = ''; // Clear previous error
      
      // Await the data from the service
      final weather = await _weatherService.fetchWeatherByCity(city.value);
      
      weatherData.value = weather; // Update observable weather data
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      weatherData.value = null; // Clear data on error
    } finally {
      isLoading.value = false;
    }
  }
}