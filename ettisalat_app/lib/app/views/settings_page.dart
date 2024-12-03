import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/map_settings_controller.dart';
import '../controllers/marker_settings_controller.dart';
import '../services/dropdown_list_widget.dart';
import '../services/settings_container_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the MapSettingsController
    final MapSettingsController mapSettingsController =
        Get.put(MapSettingsController());
    final MarkerSettingsController markerSettingsController =
        Get.put(MarkerSettingsController());

    return Scaffold(
      // appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map Settings Title
              const Row(
                children: [
                  Icon(Icons.map, size: 24, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Map Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Zoom Setting
              buildSettingContainer(
                description:
                    'The amount of proximity and distance from the points',
                title: 'Zoom',
                child: Obx(() => buildDropdownListWidget(
                      items: List.generate(
                        21,
                        (index) => DropdownMenuItem<String>(
                            value: '$index', child: Text('$index')),
                      ),
                      onChanged: (value) {
                        // Update zoom level when dropdown value changes
                        mapSettingsController.zoomLevel.value = value;
                      },
                      value: mapSettingsController.zoomLevel.value.toString(),
                    )),
              ),

              const SizedBox(height: 16),

              // Select Status Setting
              buildSettingContainer(
                description: 'Select the host state that appears on the map',
                title: 'Select Status',
                child: Obx(() => buildDropdownListWidget(
                      items: const [
                        DropdownMenuItem(
                            value: 'active', child: Text('Active')),
                        DropdownMenuItem(
                            value: 'off_less_24h', child: Text('Off Less 24h')),
                        DropdownMenuItem(
                            value: 'off_more_24h', child: Text('Off More 24h')),
                      ],
                      onChanged: (value) {
                        mapSettingsController.hostStatus.value = value;
                      },
                      value: mapSettingsController.hostStatus.value.toString(),
                    )),
              ),

              const SizedBox(height: 16),

              // Disable Double Click Zoom
              buildSettingContainer(
                description: 'When you click twice, it zooms in on the map',
                title: 'Disable Double Click Zoom',
                child: Obx(() => Switch(
                      value: mapSettingsController.disableDoubleClickZoom.value,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        mapSettingsController.disableDoubleClickZoom.value =
                            value;
                      },
                    )),
              ),

              const SizedBox(height: 16),

              // Show Places Setting
              buildSettingContainer(
                description:
                    'The ability to see places, their names, and more details about them',
                title: 'Show Places',
                child: Obx(() => Switch(
                      value: mapSettingsController.showPlaces.value,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        mapSettingsController.showPlaces.value = value;
                      },
                    )),
              ),

              const SizedBox(height: 16),

              // Show Hosts Setting
              buildSettingContainer(
                description: 'Makes hosts appear on the map',
                title: 'Show Hosts on Map',
                child: Obx(() => Switch(
                      value: mapSettingsController.showHosts.value,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        mapSettingsController.showHosts.value = value;
                      },
                    )),
              ),

              const SizedBox(height: 16),

              // Show Fibers Setting
              buildSettingContainer(
                description: 'Makes electricities appear on the map',
                title: 'Show Fibers',
                child: Obx(() => Switch(
                      value: mapSettingsController.showFibers.value,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        mapSettingsController.showFibers.value = value;
                      },
                    )),
              ),

              const SizedBox(height: 30),

              //Marker Settings

              const Row(
                children: [
                  Icon(Icons.settings, size: 24, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Marker Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Icon Size
              buildSettingContainer(
                description: 'The size of the icon that appears on the map',
                title: 'Icon Size',
                child: Obx(
                  () => buildDropdownListWidget(
                    items: const [
                      DropdownMenuItem(
                          value: '20.0', child: Text('Small Size')),
                      DropdownMenuItem(
                          value: '30.0', child: Text('Medium Size')),
                      DropdownMenuItem(
                          value: '40.0', child: Text('Large Size')),
                    ],
                    value: markerSettingsController.iconSize.value,
                    onChanged: (value) {
                      markerSettingsController.iconSize.value = double.parse(value!);
                      markerSettingsController.saveMarkerSettings();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Icon Shape
              buildSettingContainer(
                description: 'The shape of the icon that appears on the map',
                title: 'Icon Shape',
                child: Obx(
                  () => buildDropdownListWidget(
                    items: const [
                      DropdownMenuItem(value: 'wifi', child: Text('Wifi Icon')),
                      // Add more shapes if needed
                    ],
                    value: markerSettingsController.iconShape.value,
                    onChanged: (value) {
                      markerSettingsController.iconShape.value = value!;
                      markerSettingsController.saveMarkerSettings();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Draggable Icons
              buildSettingContainer(
                description: 'The icon can be moved to any place on the map',
                title: 'Draggable Icons',
                child: Obx(
                  () => Switch(
                    value: markerSettingsController.draggableIcons.value,
                    onChanged: (value) {
                      markerSettingsController.draggableIcons.value = value;
                      markerSettingsController.saveMarkerSettings();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Show Icon Title
              buildSettingContainer(
                description:
                    'Show the title of the icon when the cursor is placed on it',
                title: 'Show Icon Title',
                child: Obx(
                  () => Switch(
                    value: markerSettingsController.showIconTitle.value,
                    onChanged: (value) {
                      markerSettingsController.showIconTitle.value = value;
                      markerSettingsController.saveMarkerSettings();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Show Icon Label
              buildSettingContainer(
                description: 'Show the label on the icon to identify it',
                title: 'Show Icon Label',
                child: Obx(
                  () => Switch(
                    value: markerSettingsController.showIconLabel.value,
                    onChanged: (value) {
                      markerSettingsController.showIconLabel.value = value;
                      markerSettingsController.saveMarkerSettings();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Clickable Icons
              buildSettingContainer(
                description:
                    'Icons can be clicked when the cursor is placed on them',
                title: 'Clickable Icons',
                child: Obx(
                  () => Switch(
                    value: markerSettingsController.clickableIcons.value,
                    onChanged: (value) {
                      markerSettingsController.clickableIcons.value = value;
                      markerSettingsController.saveMarkerSettings();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Save Button
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      mapSettingsController.saveSettings();
                      markerSettingsController
                          .saveMarkerSettings(); // Save settings to SharedPreferences
                    },
                    child: const Text('Save Settings',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 10),
                  // Reset Button
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.red)),
                    onPressed: () {
                      mapSettingsController.resetSettings();
                      markerSettingsController
                          .resetSettings(); // Reset settings
                    },
                    child: const Text(
                      'Reset Settings',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
