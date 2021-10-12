import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mr_butcher/screens/butcher_home/b_bottom_navigation.dart';
import 'package:mr_butcher/size_config.dart';

import '../../constants.dart';

class Verifications extends StatefulWidget {
  static String routeName = "/verifications";

  @override
  _VerificationsState createState() => _VerificationsState();
}

class _VerificationsState extends State<Verifications> {
  int currentStep = 0;
  String storePhoneNo;
  File _userPic;
  final email = FirebaseAuth.instance.currentUser.email;
  var downUrl2;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Verification",
          style: TextStyle(color: Color(0XFF8B8B8B),),
        ),
        elevation: 2,
        centerTitle: true,
      ),
      body: Container(
        child: Stepper(
          currentStep: this.currentStep,
          steps: [
            Step(
                title: Text("Profile Picture"),
                content: picture(),
                state: StepState.editing,
                isActive: true),
          ],
          type: StepperType.vertical,
          onStepTapped: (step) {
            setState(() {
              currentStep = step;
            });
          },
        ),
      ),
    );
  }

  picture() {
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                'Profile Photo',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: kPrimaryColor,
                  child: Padding(
                    padding: EdgeInsets.all(1.5),
                    child: Stack(
                      children: [
                        Container(
                          width: 400,
                          height: 200,
                          child: _userPic != null
                              ? ClipRRect(
                                  child: Image.file(
                                    _userPic,
                                    width: 400,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                  ),
                                  width: 400,
                                  height: 200,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[800],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              MaterialButton(
                color: Colors.green,
                child: Text('ADD'),
                onPressed: () {
                  _userPhoto();
                },
              ),
              SizedBox(height: getProportionateScreenHeight(50)),
              MaterialButton(
                padding: EdgeInsets.symmetric(horizontal: 110, vertical: 5),
                color: kPrimaryColor,
                child: Text('Submit'),
                onPressed: () {
                  if (downUrl2 == null) {
                    print("Please add a picture!");
                    print(downUrl2);
                  }
                  else
                    {
                      updateData();
                      Navigator.pushReplacementNamed(context, ButcherBottomNavigation.routeName);
                    }
                },
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
            ],
          ),
        ),
      ],
    );
  }




final imagePicker = ImagePicker();

  _userPhoto() async {
    // ignore: deprecated_member_use
    final _image = await imagePicker.getImage(source: ImageSource.gallery, imageQuality: 20);
    
    File image = File(_image.path);
    
    // .pickImage(
    //     source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _userPic = image;
      uploadUserPhoto();
    });
  }

  uploadUserPhoto() async {
    final sref2 = FirebaseStorage.instance.ref().child('User Photo/$email.jpg');
    sref2.putFile(_userPic);
    //ignore: unnecessary_cast
    downUrl2 = await sref2.getDownloadURL() as String;
  }

  Future updateData() async{
    await FirebaseFirestore.instance.collection("Butchers").doc(email).update(
        {
          "User Photo": downUrl2,
          "overAllRating":"0.0",
          "BLatitude": 0.0, 
          "BLongitude": 0.0
        });
    await FirebaseFirestore.instance.collection('Users').doc(email).update({
      'User Photo': downUrl2,
    }).then((value) => {
      FirebaseAuth.instance.currentUser.updateProfile(photoURL: downUrl2),
      Navigator.pushReplacementNamed(context, ButcherBottomNavigation.routeName)
    });
  }
}