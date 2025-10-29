class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final String iconCode;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.iconCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] as String,
      // Assuming 'main' is a map containing 'temp'
      temperature: (json['main']['temp'] as num).toDouble(),
      // Assuming 'weather' is a list and we take the first element
      description: json['weather'][0]['description'] as String,
      iconCode: json['weather'][0]['icon'] as String,
    );
  }
}