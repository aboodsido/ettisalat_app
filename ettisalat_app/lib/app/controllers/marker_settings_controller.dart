import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarkerSettingsController extends GetxController {
  var iconSize = 20.0.obs;
  var iconShape = 'wifi'.obs;
  var draggableIcons = false.obs;
  var showIconTitle = true.obs;
  var showIconLabel = true.obs;
  var clickableIcons = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMarkerSettings(); // Load settings when the controller is initialized
  }

  Future<void> loadMarkerSettings() async {
    final prefs = await SharedPreferences.getInstance();
    iconSize.value = prefs.getDouble('iconSize') ?? 20;
    iconShape.value = prefs.getString('iconShape') ?? 'wifi';
    draggableIcons.value = prefs.getBool('draggableIcons') ?? false;
    showIconTitle.value = prefs.getBool('showIconTitle') ?? true;
    showIconLabel.value = prefs.getBool('showIconLabel') ?? true;
    clickableIcons.value = prefs.getBool('clickableIcons') ?? false;
  }

  Future<void> saveMarkerSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('iconSize', iconSize.value);
    await prefs.setString('iconShape', iconShape.value);
    await prefs.setBool('draggableIcons', draggableIcons.value);
    await prefs.setBool('showIconTitle', showIconTitle.value);
    await prefs.setBool('showIconLabel', showIconLabel.value);
    await prefs.setBool('clickableIcons', clickableIcons.value);
  }

  Future<void> resetSettings() async {
    iconSize.value = 20.0;
    iconShape.value = 'wifi';
    draggableIcons.value = false;
    showIconTitle.value = true;
    showIconLabel.value = true;
    clickableIcons.value = false;
    await saveMarkerSettings();
  }
}
