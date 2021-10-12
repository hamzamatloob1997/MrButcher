import 'package:flutter/material.dart';

import 'components/body.dart';

class ButcherUserPage extends StatelessWidget {
  static String routeName = '/driver_user_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
              fontFamily: 'Muli', color: Color(0XFF8B8B8B), fontSize: 18),
        ),
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: DriverBody(),
    );
  }
}
