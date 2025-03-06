import 'package:ettisalat_app/app/controllers/map_api_controller.dart';
import 'package:ettisalat_app/app/controllers/marker_settings_controller.dart';
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
  // final MapSettingsController mapSettingsController =
  //     Get.put(MapSettingsController());

  // final MarkerSettingsController markerSettingsController =
  //     Get.put(MarkerSettingsController());

  final MapApiController mapApiController = Get.find<MapApiController>();
  // String? _zoomLevel;
  // bool _disableDoubleClickZoom = false;
  // bool _showPlaces = true;
  // bool _showHosts = true;
  // bool _showFibers = false;
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    mapApiController.loadCustomIcons().then(
      (value) {
        mapApiController.fetchDevices();
      },
    );
    // Initialize settings from the controller
    // _zoomLevel = mapSettingsController.zoomLevel.value;
    // _disableDoubleClickZoom =
    //     mapSettingsController.disableDoubleClickZoom.value;
    // _showPlaces = mapSettingsController.showPlaces.value;
    // mapSettingsController.loadSettings();
    // _showHosts = mapSettingsController.showHosts.value;
    // _showFibers = mapSettingsController.showFibers.value;
    // _addHostMarkers();
    // print(_zoomLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/settings');
            },
            icon: const Icon(Icons.settings_outlined),
          )
        ],
      ),
      body: Obx(
        () {
          // if (!mapSettingsController.isLoaded.value) {
          //   // Show loading indicator while settings are being loaded
          //   return const Center(child: CircularProgressIndicator());
          // }
          return ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target:
                    const LatLng(31.5225, 34.4531), // Default camera position
                zoom: 10, // Set zoom level
              ),
              markers: mapApiController.markers.value,
              zoomGesturesEnabled: false,
              // onMapCreated: (GoogleMapController controller) {
              //   _controller = controller;
              //   _controller?.setMapStyle(
              //     _showPlaces // If true, show places; if false, hide places
              //         ? '[{"elementType": "geometry", "stylers": [{"visibility": "on"}]}, {"featureType": "poi", "elementType": "all", "stylers": [{"visibility": "on"}]}, {"featureType": "landscape", "elementType": "all", "stylers": [{"visibility": "on"}]}]'
              //         : '[{"elementType": "geometry", "stylers": [{"visibility": "on"}]}, {"featureType": "poi", "elementType": "all", "stylers": [{"visibility": "off"}]}, {"featureType": "landscape", "elementType": "all", "stylers": [{"visibility": "off"}]}]',
              //   );
              // },
              zoomControlsEnabled: true,
              buildingsEnabled: true,
            ),
          );
        },
      ),
    );
  }
}
