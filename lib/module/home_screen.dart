import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final int? selectedIndex;
  const HomeScreen({super.key, this.selectedIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.selectedIndex != null) {
      _selectedIndex = widget.selectedIndex!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Home')),
              NavigationRailDestination(icon: Icon(Icons.access_time_outlined), selectedIcon: Icon(Icons.access_time), label: Text('Absensi')),
              NavigationRailDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: Text('User')),
              NavigationRailDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: Text('Karyawan')),
              NavigationRailDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: Text('Peforma')),
              NavigationRailDestination(icon: Icon(Icons.money_outlined), selectedIcon: Icon(Icons.money), label: Text('Gaji')),
              NavigationRailDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: Text('Kalendar')),
              NavigationRailDestination(icon: Icon(Icons.announcement_outlined), selectedIcon: Icon(Icons.announcement), label: Text('Pengumuman')),
              NavigationRailDestination(icon: Icon(Icons.chat_outlined), selectedIcon: Icon(Icons.chat_rounded), label: Text('Help Chat')),
              NavigationRailDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: Text('Guidebook')),
              NavigationRailDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: Text('Pengaturan')),
            ],
          ),
          Expanded(
            child: Container(
              child: Center(
                child: Text('Selected Index: $_selectedIndex'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
