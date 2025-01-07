// import 'package:ettisalat_app/app/constants.dart';
// import 'package:ettisalat_app/app/views/map_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// import 'devices_page.dart';
// import 'settings_page.dart';
// import 'users_page.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     _tabController.addListener(() {
//       setState(() {}); // Trigger UI update when tab changes
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         bottomNavigationBar: Container(
//           height: 60,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 spreadRadius: 5,
//                 blurRadius: 20,
//                 blurStyle: BlurStyle.normal,
//               )
//             ],
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: TabBar(
//             controller: _tabController, // Attach custom TabController
//             tabs: [
//               Tab(
//                 icon: SvgPicture.asset(
//                   'assets/icons/home.svg',
//                   color: _tabController.index == 0 ? primaryColr : Colors.grey,
//                 ),
//               ),
//               Tab(
//                 icon: SvgPicture.asset(
//                   'assets/icons/user.svg',
//                   color: _tabController.index == 1 ? primaryColr : Colors.grey,
//                 ),
//               ),
//               Tab(
//                 icon: SvgPicture.asset(
//                   'assets/icons/device.svg',
//                   color: _tabController.index == 2 ? primaryColr : Colors.grey,
//                 ),
//               ),
//               Tab(
//                 icon: SvgPicture.asset(
//                   'assets/icons/more.svg',
//                   color: _tabController.index == 3 ? primaryColr : Colors.grey,
//                 ),
//               ),
//             ],
//             indicatorColor: primaryColr, // Optional: Highlight line color
//           ),
//         ),
//         body: TabBarView(
//           controller: _tabController, // Attach custom TabController
//           physics: const NeverScrollableScrollPhysics(),
//           children: [
//             const MapPage(),
//             DevicesPage(),
//             const UsersPage(),
//             const SettingsPage(),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:ettisalat_app/app/constants.dart';
import 'package:ettisalat_app/app/views/map_page.dart';
import 'package:ettisalat_app/app/views/more_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'dashboard_page.dart'; // Import the dashboard page
import 'devices_page.dart';
import 'users_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this); // Updated to 5
    _tabController.addListener(() {
      setState(() {}); // Trigger UI update when tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Updated to 5
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 60,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 5,
                blurRadius: 20,
                blurStyle: BlurStyle.normal,
              )
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: TabBar(
            indicator: const BoxDecoration(),
            controller: _tabController, // Attach custom TabController
            tabs: [
              Tab(
                icon: SvgPicture.asset(
                  'assets/icons/home.svg', // Dashboard icon
                  color: _tabController.index == 0 ? primaryColr : Colors.grey,
                ),
              ),
              Tab(
                icon: SvgPicture.asset(
                  'assets/icons/user.svg',
                  color: _tabController.index == 1 ? primaryColr : Colors.grey,
                ),
              ),
              Transform.translate(
                offset:
                    const Offset(0, -10), // Move the entire container upwards
                child: Container(
                  width: 50, // Circle diameter
                  height: 50, // Circle diameter
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: _tabController.index == 2
                            ? primaryColr
                            : Colors.white,
                        width: 1.5),
                    shape: BoxShape.circle, // Circular shape
                    color: _tabController.index == 2
                        ? Colors.white
                        : primaryColr, // Dynamic color
                    boxShadow: [
                      if (_tabController.index ==
                          2) // Optional: Shadow when active
                        const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 3),
                        ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.map_outlined, // Map icon
                      color: _tabController.index == 2
                          ? primaryColr
                          : Colors.white, // Dynamic icon color
                      size: 28, // Icon size
                    ),
                  ),
                ),
              ),
              Tab(
                icon: SvgPicture.asset(
                  'assets/icons/device.svg',
                  color: _tabController.index == 3 ? primaryColr : Colors.grey,
                ),
              ),
              Tab(
                icon: SvgPicture.asset(
                  'assets/icons/more.svg',
                  color: _tabController.index == 4 ? primaryColr : Colors.grey,
                ),
              ),
            ],
            indicatorColor: primaryColr, // Optional: Highlight line color
          ),
        ),
        body: TabBarView(
          controller: _tabController, // Attach custom TabController
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const DashboardPage(),
            const UsersPage(),
            const MapPage(),
            DevicesPage(),
            const MorePage(),
          ],
        ),
      ),
    );
  }
}
