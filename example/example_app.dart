import 'dart:async';

import 'package:google_map_with_direction_indicator/google_map_with_direction_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final locations = const [
    LatLng(37.42796133580664, -122.085749655912),
    LatLng(37.41796133580674, -122.085749655922),
    LatLng(37.43796133580684, -122.085749655932),
    LatLng(37.42796133580694, -122.095749655942),
    LatLng(37.42796133580654, -122.075749655952),
  ];

  late Set<Marker> markers;

  @override
  void initState() {
    super.initState();
    markers = locations
        .map((e) => Marker(
            markerId: MarkerId(locations.indexOf(e).toString()), position: e))
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMapWithDirectionIndicator(
      width: 200,
      height: 200,
      indicatorColor: Colors.red,
      indicatorSize: const Size(25, 25),
      controller: _controller,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: markers,
    );
  }
}
