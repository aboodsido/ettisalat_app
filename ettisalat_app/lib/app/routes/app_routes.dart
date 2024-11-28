import 'package:get/get.dart';

import '../views/home_page.dart';
import '../views/hosts_page.dart';
import '../views/login_page.dart';
import '../views/settings_page.dart';
import '../views/users_page.dart';

class AppRoutes {
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const HOSTS = '/hosts';
  static const USERS = '/users';
  static const SETTINGS = '/settings';

  static final routes = [
    GetPage(name: LOGIN, page: () => LoginPage()),
    GetPage(name: HOME, page: () => const HomePage()),
    GetPage(name: HOSTS, page: () => HostsPage()),
    GetPage(name: USERS, page: () => const UsersPage()),
    GetPage(name: SETTINGS, page: () =>  SettingsPage()),
  ];
}
