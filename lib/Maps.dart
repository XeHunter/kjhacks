import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  double lat = 19.197092;
  double lang = 72.824563;


  @override
  void initState() {
    _location();
    super.initState();
  }


  Future<void> _location() async {

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double latitude = position.latitude;
    double longitude = position.longitude;

    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks.first;
    String address = "${place.name}, ${place.locality}, ${place.country}";

    setState(() {
      lat = latitude;
      lang = longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(lat, lang),
          initialZoom: 15,
          interactionOptions: const InteractionOptions(flags: ~InteractiveFlag.doubleTapDragZoom),
        ),
        children: [
          openStreetMapTileLayer,
          MarkerLayer(markers: [
            Marker(
                point: LatLng(19.197092, 72.824563),
                width: 60,
                height: 60,
                alignment: Alignment.centerLeft,
                child: Icon(
                  CupertinoIcons.location_solid,
                  size: 30,
                  color: Colors.red,
                )),
            Marker(
                point: LatLng(19.198247, 72.827760),
                width: 60,
                height: 60,
                alignment: Alignment.centerLeft,
                child: Icon(
                  CupertinoIcons.location_solid,
                  size: 30,
                  color: Colors.red,
                )),
            Marker(
                point: LatLng(19.197092, 72.824563),
                width: 60,
                height: 60,
                alignment: Alignment.centerLeft,
                child: Icon(
                  CupertinoIcons.location_solid,
                  size: 30,
                  color: Colors.red,
                )),
            Marker(
                point: LatLng(19.202146, 72.822221),
                width: 60,
                height: 60,
                alignment: Alignment.centerLeft,
                child: Icon(
                  CupertinoIcons.location_solid,
                  size: 30,
                  color: Colors.red,
                )),
            Marker(
                point: LatLng(19.196806, 72.816846),
                width: 60,
                height: 60,
                alignment: Alignment.centerLeft,
                child: Icon(
                  CupertinoIcons.location_solid,
                  size: 30,
                  color: Colors.red,
                )),
          ]),
        ],
      ),
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);