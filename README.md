[![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)](https://pub.dev/packages/fancy_text_reveal)
![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
[![Build](https://img.shields.io/badge/licence-MIT-%23f16f12)](https://github.com/rafid08/media_picker_widget/blob/master/LICENSE)

A Flutter package that extends the Google Maps widget to provide directional indicators for markers located outside the current map view.

## Screenshots
![1](https://github.com/6cessfuldev/google_map_with_direction_indicator/assets/89137580/46a4df21-7e5d-49ac-8543-b24782d19637)
![2](https://github.com/6cessfuldev/google_map_with_direction_indicator/assets/89137580/4215801f-2e24-417e-b7bc-10a8505d7cf5)

## Features

Use this package in your Flutter app to:
* Add direction indicators pointing to a marker on Google Maps
* Customize the color and size of direction indicators.

## Getting started

1. To use this plugin, add google_maps_flutter as a dependency in your pubspec.yaml file.
2. Do the basic setup for having Google Maps
3. Create a Set of normal markers ( Set < Marker > ) and set it as markers parameter of GoogleMapWithDirectionIndicator widget
4. Import google_maps_flutter package and this package;
5. Enter parameters into the GoogleMapWithDirectionIndicator widget as you would with the GoogleMap widget
6. Enter parameters for the direction indicator as well

## Usage

```dart
GoogleMapWithDirectionIndicator(
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
```

## Additional information

### Contributing
We warmly welcome contributions to this project! If you're interested in helping improve it, please feel free to fork the repository, make your changes, and submit a pull request.

### Feedback and Suggestions
Your feedback is highly appreciated! If you have any suggestions for features or improvements, please open an issue on our GitHub repository or reach out to us directly via [email contact](mailto:6cessfuldev@gmail.com).
