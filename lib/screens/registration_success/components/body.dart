import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mr_butcher/components/default_button.dart';
import 'package:mr_butcher/methods/firebase_methods.dart';
import 'package:mr_butcher/screens/complete_profile/bcomplete_profile_screen.dart';
import 'package:mr_butcher/screens/complete_profile/vcomplete_profile_screen.dart';
import 'package:mr_butcher/size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int radioValue;
  String variable;

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
      if (radioValue == 0)
        variable = "Vendor";
      else
        variable = "Butcher";
      // print(variable);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Image.asset(
          "assets/images/success.png",
          height: SizeConfig.screenHeight * 0.4, //40%
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Text(
          "Registration Success",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(30),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text('Are you a Customer or Butcher?'),
        SizedBox(height: getProportionateScreenHeight(3)),
        Text('Please select one!'),
        SizedBox(height: getProportionateScreenHeight(8)),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.person),
              Radio(
                value: 0,
                groupValue: radioValue,
                onChanged: handleRadioValueChanged,
              ),
              Text(
                'Customer',
                style: new TextStyle(fontSize: 16.0),
              ),
              SizedBox(
                width: 50,
              ),
              Icon(MaterialCommunityIcons.knife
),
              Radio(
                value: 1,
                groupValue: radioValue,
                onChanged: handleRadioValueChanged,
              ),
              Text(
                'Butcher',
                style: new TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: SizeConfig.screenWidth * 0.6,
          child: DefaultButton(
            text: "Next",
            press: () async {
              // Navigator.pushNamed(context, HomeScreen.routeName);
              if (variable == 'Vendor')
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => VCompleteProfileScreen()));
              else if (variable == 'Butcher')
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BCompleteProfileScreen()));
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(auth.currentUser.email)
                  .update({
                'Role': variable,
              });
            },
          ),
        ),
        Spacer(),
      ],
    );
  }
}
