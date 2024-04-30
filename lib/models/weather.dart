class Weather{
  final String city;
  final double minTemp;
  final double temp;
  final double maxTemp;
  final double lon;
  final double lat;
  final String condition;

  Weather({
    required this.city,
    required this.minTemp,
    required this.temp,
    required this.maxTemp,
    required this.lon,
    required this.lat,
    required this.condition});

  factory Weather.fromJson(Map<String, dynamic> json){
    return Weather(
      city: json['name'],
      minTemp: json['main']['temp_min'].toDouble(),
      temp: json['main']['temp'].toDouble(),
      maxTemp: json['main']['temp_max'].toDouble(),
      lon: json['coord']['lon'],
      lat: json['coord']['lat'],
      condition: json['weather'][0]['main'],
    );
  }
}