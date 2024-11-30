import 'package:ettisalat_app/app/views/map_page.dart';
import 'package:flutter/material.dart';

import 'hosts_page.dart';
import 'settings_page.dart';
import 'users_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Map'),
              Tab(text: 'Hosts'),
              Tab(text: 'Users'),
              Tab(text: 'Settings'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const MapPage(),
            HostsPage(),
            const UsersPage(),
            const SettingsPage(),
          ],
        ),
      ),
    );
  }
}
