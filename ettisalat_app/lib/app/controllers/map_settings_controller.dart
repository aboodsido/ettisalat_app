import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapSettingsController extends GetxController {
  // Define settings with default values
  RxString zoomLevel = '10'.obs;
  RxString hostStatus = 'active'.obs;
  RxBool disableDoubleClickZoom = false.obs;
  RxBool showPlaces = true.obs;
  RxBool showHosts = true.obs;
  RxBool showFibers = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();  // Load settings when the app starts
  }

  // Save settings to SharedPreferences
  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('zoomLevel', zoomLevel.value);
    await prefs.setString('hostStatus', hostStatus.value);
    await prefs.setBool('disableDoubleClickZoom', disableDoubleClickZoom.value);
    await prefs.setBool('showPlaces', showPlaces.value);
    await prefs.setBool('showHosts', showHosts.value);
    await prefs.setBool('showFibers', showFibers.value);
  }

  // Load settings from SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    zoomLevel.value = prefs.getString('zoomLevel') ?? '10';
    hostStatus.value = prefs.getString('hostStatus') ?? 'active';
    disableDoubleClickZoom.value = prefs.getBool('disableDoubleClickZoom') ?? false;
    showPlaces.value = prefs.getBool('showPlaces') ?? true;
    showHosts.value = prefs.getBool('showHosts') ?? true;
    showFibers.value = prefs.getBool('showFibers') ?? false;
  }
   // Reset settings to default values
  void resetSettings() {
    zoomLevel.value = '10';
    hostStatus.value = 'active';
    disableDoubleClickZoom.value = false;
    showPlaces.value = true;
    showHosts.value = true;
    showFibers.value = false;

    // Optionally, you can clear the saved preferences as well
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('zoomLevel');
      prefs.remove('hostStatus');
      prefs.remove('disableDoubleClickZoom');
      prefs.remove('showPlaces');
      prefs.remove('showHosts');
      prefs.remove('showFibers');
    });
  }
}
