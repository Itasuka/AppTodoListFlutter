class Weather{
  final String city;
  final double temp;
  final String condition;

  Weather({
    required this.city,
    required this.temp,
    required this.condition});

  factory Weather.fromJson(Map<String, dynamic> json){
    return Weather(
      city: json['name'],
      temp: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
    );
  }
}