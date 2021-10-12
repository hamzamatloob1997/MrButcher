import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mr_butcher/constants.dart';

class DriverProfilePic extends StatefulWidget {
  const DriverProfilePic({
    Key key,
  }) : super(key: key);

  @override
  _DriverProfilePicState createState() => _DriverProfilePicState();
}

class _DriverProfilePicState extends State<DriverProfilePic> {

  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        // ignore: deprecated_member_use
        overflow: Overflow.visible,
        children: [
           CircleAvatar(
                  backgroundColor: kPrimaryColor.withOpacity(0.8),
                  child: user.photoURL == null || user.photoURL == "" ?
                  ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.asset(
                      'assets/images/User.jpeg',
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                    ),
                  ) : ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: FadeInImage.assetNetwork(
                        image: FirebaseAuth.instance.currentUser.photoURL,
                        placeholder: 'assets/images/Bubble-Loader-Icon.gif',
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover),
                  ),
                ),
        ],
      ),
    );
  }
}

// file == null? CircleAvatar(
// backgroundImage: AssetImage('assets/images/Hamza Profile.png'),
// ): Image.file(file),