import 'package:flutter/material.dart';

import 'components/vbody.dart';

class VCompleteProfileScreen extends StatelessWidget {
  static String routeName = "/p_complete_profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor'),
      ),
      body: VBody(),
    );
  }
}
