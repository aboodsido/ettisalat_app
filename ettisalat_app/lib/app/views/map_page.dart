import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/map_settings_controller.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  final MapSettingsController mapSettingsController =
      Get.put(MapSettingsController());

  final Set<Marker> _markers = {};
  String? _zoomLevel;
  bool _disableDoubleClickZoom = false;
  bool _showPlaces = true;
  // bool _showHosts = true;
  // bool _showFibers = false;

  @override
  void initState() {
    super.initState();

    // Initialize settings from the controller
    _zoomLevel = mapSettingsController.zoomLevel.value;
    _disableDoubleClickZoom =
        mapSettingsController.disableDoubleClickZoom.value;
    _showPlaces = mapSettingsController.showPlaces.value;
    // _showHosts = mapSettingsController.showHosts.value;
    // _showFibers = mapSettingsController.showFibers.value;
    // Add markersvc
    _addHostMarkers();
    mapSettingsController.loadSettings();
    print(_zoomLevel);
  }

  void _addHostMarkers() {
    // Clear existing markers
    _markers.clear();

    // Only show hosts based on the settings
    if (mapSettingsController.showHosts.value) {
      _markers.addAll({
        Marker(
          markerId: const MarkerId('host1'),
          position:
              const LatLng(31.5, 34.5), // Replace with actual host coordinates
          infoWindow: const InfoWindow(title: 'Host 1'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
        Marker(
          markerId: const MarkerId('host2'),
          position: const LatLng(
              31.23, 34.125), // Replace with actual host coordinates
          infoWindow: const InfoWindow(title: 'Host 2'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
        Marker(
          markerId: const MarkerId('host3'),
          position: const LatLng(
              31.7, 34.5782), // Replace with actual host coordinates
          infoWindow: const InfoWindow(title: 'Host 3'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        ),
      });
    }

    // Add fibers (electrical markers) if needed
    if (mapSettingsController.showFibers.value) {
      // Add your fiber markers here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          // Observe changes to settings and update map accordingly
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: const LatLng(31.7, 34.5782), // Default camera position
              zoom: double.parse(_zoomLevel!), // Set zoom level
            ),
            markers: _markers,
            zoomGesturesEnabled: !_disableDoubleClickZoom,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;

              _controller?.setMapStyle(
                _showPlaces // If true, show places; if false, hide places
                    ? '[{"elementType": "geometry", "stylers": [{"visibility": "on"}]}, {"featureType": "poi", "elementType": "all", "stylers": [{"visibility": "on"}]}, {"featureType": "landscape", "elementType": "all", "stylers": [{"visibility": "on"}]}]'
                    : '[{"elementType": "geometry", "stylers": [{"visibility": "on"}]}, {"featureType": "poi", "elementType": "all", "stylers": [{"visibility": "off"}]}, {"featureType": "landscape", "elementType": "all", "stylers": [{"visibility": "off"}]}]',
              );
            },
            zoomControlsEnabled: true,
            buildingsEnabled: mapSettingsController.showPlaces.value,
            onCameraMove: (CameraPosition position) {
              // Track zoom level and update the controller
              setState(() {
                // mapSettingsController.zoomLevel.value =
                //     position.zoom.toString();
              });
            },
          );
        },
      ),
    );
  }
}
