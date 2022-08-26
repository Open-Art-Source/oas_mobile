import 'package:flutter/material.dart';
import 'package:oas_mobile/flutx/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:oas_mobile/flutx/widgets/bottom_navigation_bar/bottom_navigation_bar_item.dart';

/// This is the stateful widget that the main application instantiates.
class LandingPageV2 extends StatefulWidget {
  const LandingPageV2({Key? key}) : super(key: key);

  @override
  State<LandingPageV2> createState() => _LandingPageV2State();
}

/// This is the private State class that goes with MyStatefulWidget.
class _LandingPageV2State extends State<LandingPageV2> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: My Collection',
      style: optionStyle,
    ),
    Text(
      'Index 2: My Work',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build_orig(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        //selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _bottomNavigationBar();
  }

  Widget _bottomNavigationBar() {
    return FxBottomNavigationBar(
      itemList: [
        FxBottomNavigationBarItem(
          title: 'Home',
          icon: Icon(Icons.home),
          page: _widgetOptions[0],
        ),
        FxBottomNavigationBarItem(
          title: 'My Collection',
          icon: Icon(Icons.collections),
          page: _widgetOptions[1],
        ),
        FxBottomNavigationBarItem(
          title: 'My Work',
          icon: Icon(Icons.work),
          page: _widgetOptions[2],
        ),
      ],
    );
  }
}
