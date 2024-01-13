import 'dart:async';

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CalculateService {
  late double widgetWidth;
  late double widgetHeight;

  Future<List<OffsetWithAngle>> calculateOffsets(
      Completer<GoogleMapController> mapController,
      List<LatLng> listLatLng,
      Size directionIndicatorSize) async {
    final GoogleMapController controller = await mapController.future;
    LatLngBounds bounds = await controller.getVisibleRegion();

    double latRange = bounds.northeast.latitude - bounds.southwest.latitude;
    double lngRange = bounds.northeast.longitude - bounds.southwest.longitude;

    double latLngRatio = latRange / lngRange;

    final LatLng mapCenterLatLng = LatLng(
        bounds.southwest.latitude + latRange / 2.0,
        bounds.southwest.longitude + lngRange / 2.0);

    List<LatLng> list = listLatLng
        .where((latLng) => !(latLng.latitude >= bounds.southwest.latitude &&
            latLng.latitude <= bounds.northeast.latitude &&
            latLng.longitude >= bounds.southwest.longitude &&
            latLng.longitude <= bounds.northeast.longitude))
        .toList();

    if (list.isNotEmpty) {
      return list
          .map((e) => calculateIndicatorPosition(
              directionIndicatorSize, e, mapCenterLatLng, latLngRatio))
          .toList();
    } else {
      return [];
    }
  }

  double calculateAngle(
      LatLng markerLatLng, LatLng centerLatLng, double latLngRatio) {
    double deltaX = markerLatLng.longitude - centerLatLng.longitude;
    double deltaY = markerLatLng.latitude - centerLatLng.latitude;

    return math.atan2(deltaY, deltaX * latLngRatio) * (180 / math.pi);
  }

  OffsetWithAngle calculateIndicatorPosition(Size directionIndicatorSize,
      LatLng markerLatLng, LatLng centerLatLng, double latLngRatio) {
    double angle = calculateAngle(markerLatLng, centerLatLng, latLngRatio);

    double centerX = widgetWidth / 2;
    double centerY = widgetHeight / 2;
    double x, y;

    // 각도에 따라 수평 또는 수직 방향 결정
    if (angle >= -45 && angle <= 45) {
      // 수직 방향 (상하단 경계)
      x = widgetWidth - directionIndicatorSize.width; // 우측 또는 좌측 경계
      y = centerY -
          centerX * math.tan(angle * math.pi / 180) +
          directionIndicatorSize.width / 2 * math.tan(angle * math.pi / 180) -
          directionIndicatorSize.height / 2;
    } else if (angle >= 135 || angle <= -135) {
      x = 0; // 우측 또는 좌측 경계
      y = centerY +
          centerX * math.tan(angle * math.pi / 180.0) -
          directionIndicatorSize.width / 2 * math.tan(angle * math.pi / 180) -
          directionIndicatorSize.height / 2;
    } else if (angle < 135 && angle > 45) {
      y = 0; // 상단 또는 하단 경계
      x = centerX -
          centerY * math.tan((angle - 90) * math.pi / 180.0) +
          directionIndicatorSize.width /
              2 *
              math.tan((angle - 90) * math.pi / 180) -
          directionIndicatorSize.height / 2;
    } else {
      // 수평 방향 (좌우측 경계)
      y = widgetHeight - directionIndicatorSize.height;
      x = centerX +
          centerY * math.tan((angle + 90) * math.pi / 180.0) -
          directionIndicatorSize.width /
              2 *
              math.tan((angle + 90) * math.pi / 180.0) -
          directionIndicatorSize.height / 2;
    }
    return OffsetWithAngle(Offset(x, y), angle);
  }
}

class OffsetWithAngle {
  Offset offset;
  double angle;

  OffsetWithAngle(this.offset, this.angle);
}
