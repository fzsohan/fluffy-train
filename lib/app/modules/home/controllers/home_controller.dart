import 'package:get/get.dart';

import '../../../../utils/api_paths.dart';
import '../../../components/custom_snackbar.dart';
import '../../../data/models/weather_model.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';


class HomeViewController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchWeather();
  }
  ///Fetch Weather Data
  final Rx<WeatherModel> weather = WeatherModel().obs;
  final Rx<ApiCallStatus> weatherApiCallStatus =
      ApiCallStatus.holding.obs;
  Future<void> fetchWeather() async {
    await BaseClient.safeApiCall(
      ApiPaths.weather,
      RequestType.get,
      onLoading: () {
        weatherApiCallStatus.value = ApiCallStatus.loading;
      },
      onSuccess: (response) {
        weatherApiCallStatus.value = ApiCallStatus.success;

        weather.value = WeatherModel.fromJson(
          response.data['data'],
        );
      },
      onError: (error) {
        weatherApiCallStatus.value = ApiCallStatus.error;
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error',
          message: error.toString(),
          statusCode: error.statusCode!,
        );
      },
    );
  }






}
