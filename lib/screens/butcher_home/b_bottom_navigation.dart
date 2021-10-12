import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:mr_butcher/constants.dart';
import 'package:mr_butcher/screens/butcher_home/pages/home_page.dart';
import 'package:mr_butcher/screens/butcher_home/pages/user_profile/user_profile.dart';

class ButcherBottomNavigation extends StatefulWidget {
  static String routeName = '/driver_navigation';

  @override
  _ButcherBottomNavigationState createState() => _ButcherBottomNavigationState();
}

class _ButcherBottomNavigationState extends State<ButcherBottomNavigation> {

  int _currentIndex = 0;
  Color selectedColor = Colors.white30;
  bool showSelectedLabels = false;
  bool showUnselectedLabels = false;

  Color unselectedColor = Colors.blueGrey;
  final BorderRadius _borderRadius = const BorderRadius.only(
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
    bottomRight: Radius.circular(25),
    bottomLeft: Radius.circular(25),
  );

  final List<Widget> _children = [
    // AddHostel(),
    ButcherHomePage(),
    ButcherUserPage(),

  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: _children[_currentIndex], // new
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: SnakeBarBehaviour.floating,
        snakeShape: SnakeShape.circle,
        backgroundColor: kPrimaryLightColor,
        shape: RoundedRectangleBorder(borderRadius: _borderRadius),
        padding: EdgeInsets.only(left: 8.0, top: 0.0, right: 8.0, bottom: 10.0),

        ///configuration for SnakeNavigationBar.color
        snakeViewColor: selectedColor,
        selectedItemColor:
        SnakeShape.circle == SnakeShape.circle ? selectedColor : null,
        unselectedItemColor: Colors.blueGrey,

        ///configuration for SnakeNavigationBar.gradient
        // snakeViewGradient: selectedGradient,
        // selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
        // unselectedItemGradient: unselectedGradient,

        showUnselectedLabels: false,
        showSelectedLabels: false,

        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,size: 40, color: kPrimaryColor,), label: 'Home',),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded,size: 40, color: kPrimaryColor,), label: 'Profile'),
        ],
        selectedLabelStyle: const TextStyle(fontSize: 14,),
        unselectedLabelStyle: const TextStyle(fontSize: 10,),
      ),

    );
  }
}
