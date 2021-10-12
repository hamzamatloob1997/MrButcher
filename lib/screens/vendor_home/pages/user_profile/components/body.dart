import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mr_butcher/screens/edit_profiles/vendor_edit_profile.dart';
import 'package:mr_butcher/screens/vendor_home/pages/user_profile/components/profile_menu.dart';
import 'package:mr_butcher/screens/sign_in/sign_in_screen.dart';
import 'package:mr_butcher/widgets/snack_bar.dart';
import 'package:mr_butcher/screens/vendor_home/pages/aboutUs.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            ProfileMenu(
              icon: 'assets/icons/User Icon.svg',
              text: 'Edit Profile',
              press: () {
                Navigator.pushNamed(context, ParentEditProfile.routeName);
              },
            ),
            // ProfileMenu(
            //   icon: 'assets/icons/Settings.svg',
            //   text: 'Settings',
            //   press: () {},
            // ),
            ProfileMenu(
              icon: 'assets/icons/Question mark.svg',
              text: 'Help Center',
              press: () {
//  Navigator.pushNamed(context, AboutUs);
                Navigator.of(context).push(
                 MaterialPageRoute(
                   builder: (context)=>
                  AboutUs()));
              },
            ),
            ProfileMenu(
              icon: 'assets/icons/Log out.svg',
              text: 'Log Out',
              press: () async {
                FirebaseAuth.instance.signOut().whenComplete(() {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                      (Route<dynamic> route) => false);
                }).catchError((e) {
                  Snack_Bar.show(context, e.message);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}


