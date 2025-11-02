import 'package:get/get.dart';
import '../../../../models/weather_model.dart';

class HomeViewController extends GetxController {
	// Temporary placeholder weather data to satisfy views until the service is wired.
	final WeatherModel weather = WeatherModel(
		cityName: 'Unknown',
		temperature: 0.0,
		description: 'N/A',
		iconCode: '',
	);
}
