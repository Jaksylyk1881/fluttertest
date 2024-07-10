import 'package:flutter/material.dart';

class CustomNavigationDestination {
  final Widget selectedIcon;
  final Widget icon;
  final String label;

  CustomNavigationDestination({
    required this.selectedIcon,
    required this.icon,
    required this.label,
  });
}

class BottomNavigationWidget extends StatefulWidget {
  final List<CustomNavigationDestination> destinations;
  final ValueChanged<int> onDestinationSelected;

  const BottomNavigationWidget({
    super.key,
    required this.destinations,
    required this.onDestinationSelected,
  });

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onDestinationSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: widget.destinations.map((destination) {
        return BottomNavigationBarItem(
          icon: destination.icon,
          label: destination.label,
          activeIcon: destination.selectedIcon,
        );
      }).toList(),
    );
  }
}
