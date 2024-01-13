import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'services/calculate_service.dart';

class GoogleMapWithDirectionIndicator extends StatefulWidget {
  const GoogleMapWithDirectionIndicator({
    super.key,
    required this.initialCameraPosition,
    this.onMapCreated,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
    this.webGestureHandling,
    this.compassEnabled = true,
    this.mapToolbarEnabled = true,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
    this.mapType = MapType.normal,
    this.minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomControlsEnabled = true,
    this.zoomGesturesEnabled = true,
    this.liteModeEnabled = false,
    // this.tiltGesturesEnabled = true,
    this.fortyFiveDegreeImageryEnabled = false,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = true,
    this.layoutDirection,
    // this.padding = EdgeInsets.zero,
    this.indoorViewEnabled = false,
    this.trafficEnabled = false,
    this.buildingsEnabled = true,
    this.markers = const <Marker>{},
    this.polygons = const <Polygon>{},
    this.polylines = const <Polyline>{},
    this.circles = const <Circle>{},
    this.onCameraMoveStarted,
    this.tileOverlays = const <TileOverlay>{},
    this.onCameraMove,
    this.onCameraIdle,
    this.onTap,
    this.onLongPress,
    this.cloudMapId,
    this.height,
    this.width,
    required this.controller,
    required MaterialColor indicatorColor,
    this.directionIndicatorSize = const Size(20, 20),
  });

  final MapCreatedCallback? onMapCreated;
  final CameraPosition initialCameraPosition;
  final bool compassEnabled;
  final bool mapToolbarEnabled;
  final CameraTargetBounds cameraTargetBounds;
  final MapType mapType;
  final TextDirection? layoutDirection;
  final MinMaxZoomPreference minMaxZoomPreference;
  final bool rotateGesturesEnabled;
  final bool scrollGesturesEnabled;
  final bool zoomControlsEnabled;
  final bool zoomGesturesEnabled;
  final bool liteModeEnabled;
  // final bool tiltGesturesEnabled;
  final bool fortyFiveDegreeImageryEnabled;
  // final EdgeInsets padding;
  final Set<Marker> markers;
  final Set<Polygon> polygons;
  final Set<Polyline> polylines;
  final Set<Circle> circles;
  final Set<TileOverlay> tileOverlays;
  final VoidCallback? onCameraMoveStarted;
  final CameraPositionCallback? onCameraMove;
  final VoidCallback? onCameraIdle;
  final ArgumentCallback<LatLng>? onTap;
  final ArgumentCallback<LatLng>? onLongPress;
  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final bool indoorViewEnabled;
  final bool trafficEnabled;
  final bool buildingsEnabled;
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;
  final WebGestureHandling? webGestureHandling;
  final String? cloudMapId;

  final Completer<GoogleMapController> controller;
  final double? width;
  final double? height;
  final Size directionIndicatorSize;

  @override
  State<GoogleMapWithDirectionIndicator> createState() =>
      _GoogleMapWithDirectionIndicatorState();
}

class _GoogleMapWithDirectionIndicatorState
    extends State<GoogleMapWithDirectionIndicator> {
  List<OffsetWithAngle> _indicatorOffsetList = [];
  late CalculateService _service;

  renderIndicator() async {
    List<OffsetWithAngle> offsets = await _service.calculateOffsets(
        widget.controller,
        widget.markers
            .map<LatLng>((marker) =>
                LatLng(marker.position.latitude, marker.position.longitude))
            .toList(),
        widget.directionIndicatorSize);
    if (mounted) {
      setState(() {
        _indicatorOffsetList = offsets;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: widget.height,
          width: widget.width,
          child: LayoutBuilder(builder: (context, constraints) {
            _service = CalculateService(
                constraints.constrainWidth(), constraints.constrainHeight());
            return Stack(
              children: [
                GoogleMap(
                  key: widget.key,
                  initialCameraPosition: widget.initialCameraPosition,
                  gestureRecognizers: widget.gestureRecognizers,
                  compassEnabled: widget.compassEnabled,
                  mapToolbarEnabled: widget.mapToolbarEnabled,
                  cameraTargetBounds: widget.cameraTargetBounds,
                  mapType: widget.mapType,
                  minMaxZoomPreference: widget.minMaxZoomPreference,
                  rotateGesturesEnabled: widget.rotateGesturesEnabled,
                  scrollGesturesEnabled: widget.scrollGesturesEnabled,
                  zoomControlsEnabled: widget.zoomControlsEnabled,
                  zoomGesturesEnabled: widget.zoomGesturesEnabled,
                  liteModeEnabled: widget.liteModeEnabled,
                  // tiltGesturesEnabled: widget.tiltGesturesEnabled,
                  tiltGesturesEnabled: false,
                  myLocationEnabled: widget.myLocationEnabled,
                  myLocationButtonEnabled: widget.myLocationButtonEnabled,
                  layoutDirection: widget.layoutDirection,
                  // padding: widget.padding,
                  indoorViewEnabled: widget.indoorViewEnabled,
                  trafficEnabled: widget.trafficEnabled,
                  buildingsEnabled: widget.buildingsEnabled,
                  markers: widget.markers,
                  polygons: widget.polygons,
                  polylines: widget.polylines,
                  circles: widget.circles,
                  onCameraMoveStarted: widget.onCameraMoveStarted,
                  tileOverlays: widget.tileOverlays,
                  onCameraIdle: widget.onCameraIdle,
                  onTap: widget.onTap,
                  onLongPress: widget.onLongPress,
                  onMapCreated: (controller) {
                    widget.onMapCreated!(controller);
                    renderIndicator();
                  },
                  onCameraMove: (position) {
                    if (widget.onCameraMove != null) {
                      widget.onCameraMove!(position);
                    }
                    renderIndicator();
                  },
                ),
                if (widget.markers.isNotEmpty)
                  ..._indicatorOffsetList.map<Widget>((el) {
                    return Positioned(
                      left: el.offset.dx,
                      top: el.offset.dy,
                      child: IgnorePointer(
                        ignoring: true,
                        child: Transform.rotate(
                          angle: -el.angle * math.pi / 180,
                          child: Image.asset(
                            'assets/images/arrow.png',
                            color: Colors.blue,
                            height: widget.directionIndicatorSize.height,
                            width: widget.directionIndicatorSize.width,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
              ],
            );
          }),
        ),
      ),
    );
  }
}
