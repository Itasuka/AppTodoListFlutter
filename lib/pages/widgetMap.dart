import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/colors.dart';
import '../models/weather.dart';

///Affichage de la map en plein écran sur un nouveau widget
class WidgetMap extends StatelessWidget {
  final Weather weather;
  final String title;

  const WidgetMap({super.key, required this.title, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().buttonColor(),
        title: Text('Carte de "$title"', style: TextStyle(color: AppColor().insideButtonColor()),),
      ),
      body: Center(
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(weather.lat, weather.lon),
            initialZoom: 11,

          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'dev.fleaflet.flutter_map.example',
            ),
            MarkerLayer(markers: [
              Marker(
                point:LatLng(weather.lat, weather.lon),
                width: 60,
                height: 60,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.location_pin,
                  size: 60,
                  color: Colors.red,
                )
              )
            ]),
          ],
        ),
      ),
    );
  }
}