import 'dart:async';

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CalculateService {
  late double _widgetWidth;
  late double _widgetHeight;
  late double _topRightDiagonalAngle;

  CalculateService(double widgetWidth, double widgetHeight) {
    _widgetWidth = widgetWidth;
    _widgetHeight = widgetHeight;
    _topRightDiagonalAngle = calculateDiagonalAngle(widgetWidth, widgetHeight);
  }

  double calculateDiagonalAngle(double width, double height) {
    return math.atan2(height, width) * 180 / math.pi;
  }

  Future<List<OffsetWithAngle>> calculateOffsets(
      Completer<GoogleMapController> mapController,
      List<LatLng> listLatLng,
      Size directionIndicatorSize) async {
    final GoogleMapController controller = await mapController.future;
    LatLngBounds bounds = await controller.getVisibleRegion();

    double latRange = bounds.northeast.latitude - bounds.southwest.latitude;
    double lngRange = bounds.northeast.longitude - bounds.southwest.longitude;
    double latPerPixel = _widgetHeight / latRange;
    double lngPerPixel = _widgetWidth / lngRange;

    final LatLng mapCenterLatLng = LatLng(
        bounds.southwest.latitude + latRange / 2.0,
        bounds.southwest.longitude + lngRange / 2.0);

    List<LatLng> resList = listLatLng
        .where((latLng) => !(latLng.latitude >= bounds.southwest.latitude &&
            latLng.latitude <= bounds.northeast.latitude &&
            latLng.longitude >= bounds.southwest.longitude &&
            latLng.longitude <= bounds.northeast.longitude))
        .toList();

    return resList
        .map((e) => calculateIndicatorPosition(directionIndicatorSize, e,
            mapCenterLatLng, latPerPixel, lngPerPixel))
        .toList();
  }

  OffsetWithAngle calculateIndicatorPosition(
      Size directionIndicatorSize,
      LatLng markerLatLng,
      LatLng centerLatLng,
      double latPerPixel,
      double lngPerPixel) {
    double angle =
        calculateAngle(markerLatLng, centerLatLng, latPerPixel, lngPerPixel);

    double centerX = _widgetWidth / 2;
    double centerY = _widgetHeight / 2;
    double x, y;

    if (angle >= -_topRightDiagonalAngle && angle <= _topRightDiagonalAngle) {
      x = _widgetWidth - directionIndicatorSize.width;
      y = centerY -
          centerX * math.tan(angle * math.pi / 180) +
          directionIndicatorSize.width / 2 * math.tan(angle * math.pi / 180) -
          directionIndicatorSize.height / 2;
    } else if (angle >= 180 - _topRightDiagonalAngle ||
        angle <= -180 + _topRightDiagonalAngle) {
      x = 0;
      y = centerY +
          centerX * math.tan(angle * math.pi / 180.0) -
          directionIndicatorSize.width / 2 * math.tan(angle * math.pi / 180) -
          directionIndicatorSize.height / 2;
    } else if (angle < 180 - _topRightDiagonalAngle &&
        angle > _topRightDiagonalAngle) {
      y = 0;
      x = centerX -
          centerY * math.tan((angle - 90) * math.pi / 180.0) +
          directionIndicatorSize.width /
              2 *
              math.tan((angle - 90) * math.pi / 180) -
          directionIndicatorSize.height / 2;
    } else {
      y = _widgetHeight - directionIndicatorSize.height;
      x = centerX +
          centerY * math.tan((angle + 90) * math.pi / 180.0) -
          directionIndicatorSize.width /
              2 *
              math.tan((angle + 90) * math.pi / 180.0) -
          directionIndicatorSize.height / 2;
    }
    return OffsetWithAngle(Offset(x, y), angle);
  }

  /// calculate the angle between marker position and map's center position.
  /// Calculate the angle between two latitude and longitude points,
  /// and then apply the latitude and longitude ratio of Google Maps
  /// to determine the actual rendered angle.
  double calculateAngle(LatLng markerLatLng, LatLng centerLatLng,
      double latPerPixel, double lngPerPixel) {
    double deltaX =
        (markerLatLng.longitude - centerLatLng.longitude) * lngPerPixel;
    double deltaY =
        (markerLatLng.latitude - centerLatLng.latitude) * latPerPixel;

    return math.atan2(deltaY, deltaX) * (180 / math.pi);
  }
}

class OffsetWithAngle {
  Offset offset;
  double angle;

  OffsetWithAngle(this.offset, this.angle);
}
