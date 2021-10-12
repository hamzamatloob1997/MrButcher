import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mr_butcher/methods/firebase_methods.dart';
import 'package:mr_butcher/models/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';
import 'user_profile/components/ButcherModel.dart';

class SearchButchers extends StatefulWidget {
  Butcher butcher;

  SearchButchers({this.butcher});

  @override
  _SearchButchersState createState() => _SearchButchersState();
}

class _SearchButchersState extends State<SearchButchers> {
  double starSize = 25;
  String name;
  String phoneNo;
  String address;
  String currentUser;
  double lat;
  double lon;

    Future getUserData() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser.email)
        .get()
        .then((value) {
      var user = value.data();
      name = (user['displayName']);
      phoneNo = (user['PhoneNumber']);
      address = (user['address']);
    });
  }

  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print(' could not launch $command');
    }
  }

  Future<bool> checkRequest(dynamic email) async {
    //
    bool isRequested = false;
    await FirebaseFirestore.instance
        .collection("Booking Requests")
        .where('user Email', isEqualTo: FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) {
      var data = value.docs;
      data.forEach((element) {
        // print("email===>>>> ${email}");
        if (email == element['Butcher Email']) {
          isRequested = true;
        }
      });
    });
    return isRequested;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Results"),),
          body: Container(
          child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(7),
        child: ExpansionTile(
          onExpansionChanged: (value) async {
            if (value) {
              // await checkRequest();
            }
          },
          leading: CircleAvatar(
            radius: 22,
            backgroundColor: kPrimaryColor.withOpacity(0.8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(70),
              child: FadeInImage.assetNetwork(
                image: widget.butcher.userPhoto,
                placeholder: 'assets/images/Bubble-Loader-Icon.gif',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100.0,
                child: Text(
                  widget.butcher.name.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
              // Text("$distance2 m")
              // FutureBuilder(
              //   future: getCurrentLocation(snapshot['BLatitude'],snapshot['BLongitude']),
              //   builder: (context,snapshot){
              //     return Text(" ${snapshot.data} KM",
              //     style: TextStyle(color: Colors.green),
              //     );
              //   })
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 120.0,
                  child: Text(widget.butcher.address,
                      overflow: TextOverflow.ellipsis)),
              Text(
                widget.butcher.overAllRating.substring(0, 3) + "🌟",
                style: TextStyle(color: Colors.deepOrange),
              ),
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Phone No: ${widget.butcher.phoneNo}'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Rates for my work are following:'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Hen: ${widget.butcher.henButcheringRate}'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child:
                  Text('Goat or Lamb: ${widget.butcher.goatLambButcheringRate}'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Cattle: ${widget.butcher.cattleRate}'),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: checkRequest(widget.butcher.email),
                      builder: (context, snapshotData) {
                        // print("Bucking Email === > ${snapshotData.data}");

                        return MaterialButton(
                          color: kPrimaryColor,
                          onPressed: () async {
                            // print(snapshot['Email'].toString());
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  ProgressDialog(message: "Please wait..."),
                            );
                            try {
                              await getUserData().then((value) {
                                //  var user = value.data();
                                // name = (user['displayName']);
                                // phoneNo = (user['phoneNo']);
                                // address = (user['Address']);

                                if (name == null ||
                                    address == null ||
                                    phoneNo == null ||
                                    widget.butcher.email == null ||
                                    auth.currentUser.email == null) {
                                  var snackBar = SnackBar(
                                      content: Text("Details not correct"));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  FirebaseFirestore.instance
                                      .collection('Booking Requests')
                                      .add({
                                    'Customer Name': name,
                                    'Customer Address': address,
                                    'Customer PhoneNo': phoneNo,
                                    'user Email': auth.currentUser.email,
                                    'Butcher Name': widget.butcher.name,
                                    'Butcher PhoneNo': widget.butcher.phoneNo,
                                    'Butcher Email': widget.butcher.email,
                                    'Butcher Address': widget.butcher.address,
                                    'status': "pending",
                                    'rating': "0"
                                  }).then((value) {
                                    setState(() {});
                                  });
                                }
                              });
                            } catch (e) {
                              print(e);
                            }
                            Navigator.pop(context);
                          },
                          child: Text("Book"),
                        );
                      }),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: MaterialButton(
                      onPressed: () {
                        customLaunch('tel:${widget.butcher.phoneNo}');
                      },
                      color: kPrimaryColor,
                      child: Text('Call'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),),
    
    
    );
  }
}
