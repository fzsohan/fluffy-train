
class WeatherModel {
   double? temperature;
   String? description;
   String? iconCode;
   String? cityName;
   double? feelsLike;
   int? humidity;
   double? windSpeed;

  WeatherModel({
     this.temperature,
     this.description,
     this.iconCode,
     this.cityName,
     this.feelsLike,
     this.humidity,
     this.windSpeed,
  });

   WeatherModel.fromJson(Map<String, dynamic> json) {
      temperature = json['main']['temp']?.toDouble();
      description= json['weather'][0]['description']?.toString();
      iconCode = json['weather'][0]['icon']?.toString();
      cityName= json['name']?.toString();
      feelsLike= json['main']['feels_like']?.toDouble();
      humidity= json['main']['humidity']?.toInt();
      windSpeed= json['wind']['speed']?.toDouble();  
  }

Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['main']['temp'] = temperature;
    data ['weather'][0]['description']= description;
    data['weather'][0]['icon'] = iconCode;
    data['name'] = cityName;
    data['main']['feels_like'] = feelsLike;
    data['main']['humidity'] = humidity; 
    data['wind']['speed'] = windSpeed;
    return data;
  }
}
class Report {
  String? value;
  bool? isIncreased;

  Report({this.value, this.isIncreased});

  Report.fromJson(Map<String, dynamic> json) {
    value = json['value']?.toString();
    isIncreased = json['is_increased'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['is_increased'] = isIncreased;
    return data;
  }
  }