import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:mr_butcher/constants.dart';
import 'package:mr_butcher/methods/firebase_methods.dart';
import 'package:mr_butcher/screens/vendor_home/pages/aboutUs.dart';
import 'package:search_page/search_page.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mr_butcher/models/progress_dialog.dart';
import 'locationModel.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'distance_model.dart';
import 'searchButcher.dart';
import 'user_profile/components/ButcherModel.dart';
import 'user_profile/components/body.dart';
// import 'package:vector_math/vector_math_geometry.dart';

class HomePage extends StatefulWidget {
  final String routeName = '/tracking_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double starSize = 25;

  String name;
  String phoneNo;
  String address;
  String currentUser;
  double lat;
  double lon;

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

  Future getUserData() async {
    await FirebaseFirestore.instance
        .collection('Vendors')
        .doc(auth.currentUser.email)
        .get()
        .then((value) {
      var user = value.data();
      name = (user['Name']);
      phoneNo = (user['PhoneNo']);
      address = (user['Address']);
    });
  }

  var lat1;
  var lon1;
  Future<LocationModel> getUserLocation() async {
    await FirebaseFirestore.instance
        .collection('Vendors')
        .doc(auth.currentUser.email)
        .get()
        .then((value) {
      var user = value.data();
      lat1 = (user['VLatitude']);
      lon1 = (user['VLongitude']);
      return LocationModel(user['VLatitude'], user['VLongitude']);
    });
    return LocationModel(lat1, lon1);
  }

  var locationMessage = "";
// List<double> list;
  Future<ButcherDistance> getCurrentLocation(double lat1, double lon1) async {
    // var position = await Geolocator().
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
// Position lastPosition = await Geolocator.getLastKnownPosition();

// print(position.toString());

// var lat2 =34.1023;
// var long2 = 71.4804;

// var lat3=31.4024;
// var long3 = 76.1151;

// FirebaseFirestore.instance.collection("Vendors").doc(auth.currentUser.email).update({
//   "VLatitude":position.latitude,
//   "VLongitude":position.longitude
// });
    var distance = Geolocator.distanceBetween(
        position.latitude, position.longitude, lat1, lon1);
// print("Mathra Distance# $distance");
// setState(() {
//   locationMessage = "$position.latitude , $position.longitude";
// });

// setState(() {
//  list=[position.latitude,position.longitude];
// });

// print(position.latitude.toString());

    if (distance <= 1000) {
      return ButcherDistance(
        distance: (distance).toStringAsFixed(2) == null
            ? "0"
            : (distance).toStringAsFixed(2),
        isNear: true,
        isNormalUnit:"m"
      );
    } else if (  distance >= 1000 &&  distance <= 10000) {
      return ButcherDistance(
        distance: (distance).toStringAsFixed(2) == null
            ? "0"
            : (distance/1000).toStringAsFixed(2),
        isNear: true,
        isNormalUnit: "km"
      );
    } else if (distance >= 10000) {
      return ButcherDistance(
        distance: (distance).toStringAsFixed(2) == null
            ? "0"
            : (distance/1000).toStringAsFixed(2),
        isNear: false,
        isNormalUnit: "KM"
      );
    } else{
      return ButcherDistance(
        distance: "0",
        isNear: true,
        isNormalUnit:""
      );
    }

    //LocationModel(position.latitude, position.longitude);
  }

  butcherList(DocumentSnapshot jsnapshot, index) {
    // bool isNear = true;
    return FutureBuilder(
                future: getCurrentLocation(
                    jsnapshot['BLatitude'], jsnapshot['BLongitude']),
                builder: (context, AsyncSnapshot<ButcherDistance> snapshot) {
                  if (snapshot.hasData) {
                   
                      // isNear = snapshot.data.isNear;
                    
                    if(snapshot.data.isNear){
                      return     Card(
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
              image: jsnapshot['User Photo'],
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
                jsnapshot['Name'].toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
            // Text("$distance2 m")
            FutureBuilder(
                future: getCurrentLocation(
                    jsnapshot['BLatitude'], jsnapshot['BLongitude']),
                builder: (context, AsyncSnapshot<ButcherDistance> snapshot) {
                  if (snapshot.hasData) {
                   
                      // isNear = snapshot.data.isNear;
                    
                    return Text(
                      " ${snapshot.data.distance.toString() } ${snapshot.data.isNormalUnit.toString()}",
                      style: TextStyle(color: Colors.green),
                    );
                  } else {
                    return SizedBox();
                  }
                })
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 120.0,
              child: Text(jsnapshot['city'], overflow: TextOverflow.ellipsis),
            ),
            Text(
              jsnapshot['overAllRating'].substring(0, 3) + "🌟",
              style: TextStyle(color: kPrimaryColor),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Phone No: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '${jsnapshot['PhoneNo']}'),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Address: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '${jsnapshot['Address']}'),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Rates for my work are following:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Hen: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '${jsnapshot['HenButcheringRate']}'),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Goat or Lamb: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '${jsnapshot['GoatLambButcheringRate']}'),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Cattle: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '${jsnapshot['CattleRate']}'),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder(
                          future: checkRequest(jsnapshot['Email']),
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
                                        jsnapshot['Email'] == null ||
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
                                        'Butcher Name': jsnapshot['Name'],
                                        'Butcher PhoneNo': jsnapshot['PhoneNo'],
                                        'Butcher Email': jsnapshot['Email'],
                                        'Butcher Address': jsnapshot['Address'],
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
                              child: Text("Book", style: txtlight),
                            );
                          }),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                      MaterialButton(
                        onPressed: () {
                          customLaunch('tel:${jsnapshot['PhoneNo']}');
                        },
                        color: kPrimaryColor,
                        child: Text('Call', style: txtlight),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  

                    } else {

                      return SizedBox();
                    }
                  } else {
                    return SizedBox();
                  }
                });
    
    
    

  }

  rejectedListCard(DocumentSnapshot snapshot) {
    print(snapshot.id.toString());
    if (snapshot['status'] != null && snapshot['status'] == "pending" ||
        snapshot['status'] == "rejected") {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(7),
        child: ExpansionTile(
          leading: CircleAvatar(
            radius: 22,
            backgroundColor: kPrimaryColor.withOpacity(0.8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(70),
              child: Image.asset(
                'assets/images/User.jpeg',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  snapshot['Butcher Name'] == null
                      ? "Name not correct"
                      : snapshot['Butcher Name'].toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.7))),
              Text(
                snapshot['status'] == null
                    ? "Nil"
                    : snapshot['status'].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  // color: Colors.black.withOpacity(0.7),
                  color: snapshot['status'] == "pending"
                      ? Colors.black
                      : Colors.red,
                ),
              ),
            ],
          ),
          subtitle: Text(snapshot['Butcher Address'].toString()),
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('B.Phone No: ${snapshot['Butcher PhoneNo']}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 20),
                // ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: MaterialButton(
                    color: kPrimaryColor,
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            ProgressDialog(message: "Please wait..."),
                      );
                      try {
                        FirebaseFirestore.instance
                            .collection('Booking Requests')
                            .doc(snapshot.id)
                            .delete()
                            .then((value) {
                          setState(() {});
                        });
                      } catch (e) {
                        print(e);
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  // child: Text('Accept'),
                  // ),
                ),
                //                Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 20),
                // ),

                // Padding(
                //   padding: EdgeInsets.only(bottom: 10),
                //   child: MaterialButton(
                //     onPressed: () {
                //       customLaunch('tel:${snapshot['Customer PhoneNo']}');
                //     },
                //     color: kPrimaryColor,
                //     child: Text('Call', style:TextStyle(color: Colors.white)),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: SizedBox(),
      ); //No Bookings Request Found
    }
  }

  acceptedListCard(DocumentSnapshot snapshot) {
    // print(snapshot.id.toString());
    if (snapshot['status'] == null && snapshot['status'] == "started" ||
        snapshot['status'] == "completed") {
      return Column(
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(7),
            child: ListTile(
              leading: CircleAvatar(
                radius: 22,
                backgroundColor: kPrimaryColor.withOpacity(0.8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: Image.asset(
                    'assets/images/User.jpeg',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      snapshot['Butcher Name'] == null
                          ? "Name not correct"
                          : snapshot['Butcher Name'].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.7))),
                  Text(
                    snapshot['status'] == null
                        ? "Nil"
                        : snapshot['status'].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // color: Colors.black.withOpacity(0.7),
                      color: snapshot['status'] == "started"
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
              subtitle: (snapshot['status'] == "completed" &&
                      snapshot['rating'] == "0")
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        oneStar(snapshot),
                        twoStar(snapshot),
                        threeStar(snapshot),
                        fourStar(snapshot),
                        fiveStar(snapshot),
                      ],
                    )
                  : SmoothStarRating(
                      allowHalfRating: false,
                      onRated: (v) {
                        print("$v");
                      },
                      starCount: int.parse(snapshot['rating']),
                      rating: double.parse(snapshot['rating']),
                      size: 15.0,
                      isReadOnly: true,
                      color: Colors.green,
                      borderColor: Colors.green,
                      spacing: 0.0),
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: SizedBox(),
      ); //No Bookings Request Found
    }
  }

  InkWell fiveStar(DocumentSnapshot snapshot) {
    return InkWell(
      onTap: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              ProgressDialog(message: "Please wait..."),
        );
        try {
          FirebaseFirestore.instance
              .collection('Booking Requests')
              .doc(snapshot.id)
              .update({
            'rating': "5",
          }).then((value) {
            double myvar;
            FirebaseFirestore.instance
                .collection("Butchers")
                .doc(snapshot["Butcher Email"])
                .get()
                .then((value) {
              myvar = double.parse(value.data()['overAllRating']) == 0.0
                  ? 5.00
                  : ((double.parse(value.data()['overAllRating']) + 5.00) / 2);
              print(myvar.toString());
              FirebaseFirestore.instance
                  .collection("Butchers")
                  .doc(snapshot["Butcher Email"])
                  .update({"overAllRating": myvar.toString()});
            });
            Fluttertoast.showToast(
                msg: "5 star rating added",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            setState(() {});
          });
        } catch (e) {
          print(e);
        }
        Navigator.pop(context);
      },
      child: Icon(
        Icons.star_border,
        size: starSize,
        color: kPrimaryColor,
      ),
    );
  }

  InkWell fourStar(DocumentSnapshot snapshot) {
    return InkWell(
      onTap: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              ProgressDialog(message: "Please wait..."),
        );
        try {
          FirebaseFirestore.instance
              .collection('Booking Requests')
              .doc(snapshot.id)
              .update({
            'rating': "4",
          }).then((value) {
            double myvar;
            FirebaseFirestore.instance
                .collection("Butchers")
                .doc(snapshot["Butcher Email"])
                .get()
                .then((value) {
              myvar = double.parse(value.data()['overAllRating']) == 0.0
                  ? 4.00
                  : ((double.parse(value.data()['overAllRating']) + 4.00) / 2);
              print(myvar.toString());
              FirebaseFirestore.instance
                  .collection("Butchers")
                  .doc(snapshot["Butcher Email"])
                  .update({"overAllRating": myvar.toString()});
            });

            Fluttertoast.showToast(
                msg: "4 star rating added",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            setState(() {});
          });
        } catch (e) {
          print(e);
        }
        Navigator.pop(context);
      },
      child: Icon(
        Icons.star_border,
        size: starSize,
        color: kPrimaryColor,
      ),
    );
  }

  InkWell threeStar(DocumentSnapshot snapshot) {
    return InkWell(
      onTap: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              ProgressDialog(message: "Please wait..."),
        );
        try {
          double myvar;
          FirebaseFirestore.instance
              .collection("Butchers")
              .doc(snapshot["Butcher Email"])
              .get()
              .then((value) {
            myvar = double.parse(value.data()['overAllRating']) == 0.0
                ? 3.00
                : ((double.parse(value.data()['overAllRating']) + 3.00) / 2);
            print(myvar.toString());
            FirebaseFirestore.instance
                .collection("Butchers")
                .doc(snapshot["Butcher Email"])
                .update({"overAllRating": myvar.toString()});
          });

          FirebaseFirestore.instance
              .collection('Booking Requests')
              .doc(snapshot.id)
              .update({
            'rating': "3",
          }).then((value) {
            Fluttertoast.showToast(
                msg: "3 star rating added",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            setState(() {});
          });
        } catch (e) {
          print(e);
        }
        Navigator.pop(context);
      },
      child: Icon(
        Icons.star_border,
        size: starSize,
        color: kPrimaryColor,
      ),
    );
  }

  InkWell twoStar(DocumentSnapshot snapshot) {
    return InkWell(
      onTap: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              ProgressDialog(message: "Please wait..."),
        );
        try {
          double myvar;
          FirebaseFirestore.instance
              .collection("Butchers")
              .doc(snapshot["Butcher Email"])
              .get()
              .then((value) {
            myvar = double.parse(value.data()['overAllRating']) == 0.0
                ? 2.00
                : ((double.parse(value.data()['overAllRating']) + 2.00) / 2);
            print(myvar.toString());
            FirebaseFirestore.instance
                .collection("Butchers")
                .doc(snapshot["Butcher Email"])
                .update({"overAllRating": myvar.toString()});
          });
          FirebaseFirestore.instance
              .collection('Booking Requests')
              .doc(snapshot.id)
              .update({
            'rating': "2",
          }).then((value) {
            Fluttertoast.showToast(
                msg: "2 star rating added",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            setState(() {});
          });
        } catch (e) {
          print(e);
        }
        Navigator.pop(context);
      },
      child: Icon(
        Icons.star_border,
        size: starSize,
        color: kPrimaryColor,
      ),
    );
  }

  InkWell oneStar(DocumentSnapshot snapshot) {
    return InkWell(
      onTap: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              ProgressDialog(message: "Please wait..."),
        );
        try {
          // Add rating snapshot here

          FirebaseFirestore.instance
              .collection('Booking Requests')
              .doc(snapshot.id)
              .update({
            'rating': "1",
          }).then((value) {
            double myvar;
            FirebaseFirestore.instance
                .collection("Butchers")
                .doc(snapshot["Butcher Email"])
                .get()
                .then((value) {
              myvar = (double.parse(value.data()['overAllRating']) == 0.0
                  ? 1.00
                  : ((double.parse(value.data()['overAllRating']) + 1.00) / 2));
              print(myvar.toString());
              FirebaseFirestore.instance
                  .collection("Butchers")
                  .doc(snapshot["Butcher Email"])
                  .update({"overAllRating": myvar.toString()});
            });

            Fluttertoast.showToast(
                msg: "1 star rating added",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            setState(() {});
          });
        } catch (e) {
          print(e);
        }
        Navigator.pop(context);
      },
      child: Icon(
        Icons.star_border,
        size: starSize,
        color: kPrimaryColor,
      ),
    );
  }

  List<Butcher> listButchers = [];
  mySearchFunction() async {
    var mynewf = await FirebaseFirestore.instance
        .collection('Butchers')
        .get()
        .then((value) {
      var maps = value.docs;
      maps.forEach((element) {
        // final butcher = butcherFromJson(element);
        listButchers.add(Butcher(
          email: element.data()["Email"],
          bLatitude: element.data()["BLatitude"],
          address: element.data()["Address"],
          city: element.data()["city"],
          henButcheringRate: element.data()["HenButcheringRate"],
          userPhoto: element.data()["User Photo"],
          name: element.data()["Name"],
          overAllRating: element.data()["overAllRating"],
          goatLambButcheringRate: element.data()["GoatLambButcheringRate"],
          cattleRate: element.data()["CattleRate"],
          phoneNo: element.data()["PhoneNo"],
          cnic: element.data()["CNIC"],
          bLongitude: element.data()["BLongitude"],
        ));
      });
    });
    print(listButchers[0].city);
    return listButchers;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mySearchFunction();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 2,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              'Home Page',
              style: TextStyle(
                  fontFamily: 'Muli', color: Color(0XFF8B8B8B), fontSize: 18),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                scaffoldKey.currentState.openEndDrawer();
              },
              icon: Icon(Icons.search_sharp, color: kPrimaryColor),
            ),
          ],
          backgroundColor: hexColor,
          bottom: TabBar(
              labelColor: kPrimaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: kPrimaryColor,
              tabs: [
                Tab(text: "Butchers"),
                Tab(text: "Rejected"),
                Tab(text: "Approved"),
              ]),
        ),
        endDrawer: Container(
          width: 220.0,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // height: 150.0,
                width: 220.0,
                color: Colors.black,
                child: Column(
                  children: [
                    SizedBox(height: 25.0),
                    Stack(
                      children: [
                        SizedBox(height: 25.0),
                        Image.asset("assets/images/butcher_2.png"),
                        // CircleAvatar(
                        //   radius: 50.0,
                        //   backgroundImage: AssetImage("assets/images/butcher_2.png"),
                        // ),
                        Positioned(
                          // alignment: Alignment.center,
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Colors.red.withOpacity(0.7), BlendMode.darken),
                            child: SizedBox(
                              child: Text(
                                "Find Butchers",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Find Butchers",
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: Colors.black),
                ),
              ),
              MaterialButton(
                // style:ButtonStyle(
                //   backgroundColor: Colors.grey,
                // ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search, size: 15.0, //color: kPrimaryColor,
                    ),
                    SizedBox(width: 10.0),
                    Text("Search By City"),
                  ],
                ),
                onPressed: () => showSearch(
                  context: context,
                  delegate: SearchPage<Butcher>(
                    barTheme: ThemeData.dark(),
                    items: listButchers,
                    searchLabel: 'Search by City',
                    suggestion: Center(
                      child: Text('Filter Butcher by city'),
                    ),
                    failure: Center(
                      child: Text('No person found :('),
                    ),
                    filter: (person) => [
                      person.name,
                      person.city,
                      person.phoneNo.toString(),
                    ],
                    builder: (butcher) => Card(
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
                              image: butcher.userPhoto,
                              placeholder:
                                  'assets/images/Bubble-Loader-Icon.gif',
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
                                butcher.name.toUpperCase(),
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
                                child: Text(butcher.city,
                                    overflow: TextOverflow.ellipsis)),
                            Text(
                              butcher.overAllRating.substring(0, 3) + "🌟",
                              style: TextStyle(color: Colors.deepOrange),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Phone No: ${butcher.phoneNo}'),
                          ),
                          Text(butcher.address,
                              overflow: TextOverflow.ellipsis),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Rates for my work are following:'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Hen: ${butcher.henButcheringRate}'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                                'Goat or Lamb: ${butcher.goatLambButcheringRate}'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Cattle: ${butcher.cattleRate}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FutureBuilder(
                                    future: checkRequest(butcher.email),
                                    builder: (context, snapshotData) {
                                      // print("Bucking Email === > ${snapshotData.data}");

                                      return MaterialButton(
                                        color: kPrimaryColor,
                                        onPressed: () async {
                                          // print(snapshot['Email'].toString());
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                ProgressDialog(
                                                    message: "Please wait..."),
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
                                                  butcher.email == null ||
                                                  auth.currentUser.email ==
                                                      null) {
                                                var snackBar = SnackBar(
                                                    content: Text(
                                                        "Details not correct"));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              } else {
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        'Booking Requests')
                                                    .add({
                                                  'Customer Name': name,
                                                  'Customer Address': address,
                                                  'Customer PhoneNo': phoneNo,
                                                  'user Email':
                                                      auth.currentUser.email,
                                                  'Butcher Name': butcher.name,
                                                  'Butcher PhoneNo':
                                                      butcher.phoneNo,
                                                  'Butcher Email':
                                                      butcher.email,
                                                  'Butcher Address':
                                                      butcher.address,
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
                                MaterialButton(
                                  onPressed: () {
                                    customLaunch('tel:${butcher.phoneNo}');
                                  },
                                  color: kPrimaryColor,
                                  child: Text('Call'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              MaterialButton(
                // style:ButtonStyle(
                //   backgroundColor: Colors.grey,
                // ),
                child: Row(
                  children: [
                    Icon(Icons.search, size: 15.0),
                    SizedBox(width: 10.0),
                    Text("Search By Name"),
                  ],
                ),
                onPressed: () => showSearch(
                  context: context,
                  delegate: SearchPage<Butcher>(
                    barTheme: ThemeData.dark(),
                    items: listButchers,
                    searchLabel: 'Search Butcher Name',
                    suggestion: Center(
                      child: Text('Filter Butcher by name'),
                    ),
                    failure: Center(
                      child: Text('No person found :('),
                    ),
                    filter: (person) => [
                      person.name,
                      person.city,
                      person.phoneNo.toString(),
                    ],
                    builder: (butcher) => Card(
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
                              image: butcher.userPhoto,
                              placeholder:
                                  'assets/images/Bubble-Loader-Icon.gif',
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
                                butcher.name.toUpperCase(),
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
                                child: Text(butcher.address,
                                    overflow: TextOverflow.ellipsis)),
                            Text(
                              butcher.overAllRating.substring(0, 3) + "🌟",
                              style: TextStyle(color: Colors.deepOrange),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Phone No: ${butcher.phoneNo}'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Rates for my work are following:'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Hen: ${butcher.henButcheringRate}'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                                'Goat or Lamb: ${butcher.goatLambButcheringRate}'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Cattle: ${butcher.cattleRate}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FutureBuilder(
                                    future: checkRequest(butcher.email),
                                    builder: (context, snapshotData) {
                                      // print("Bucking Email === > ${snapshotData.data}");

                                      return MaterialButton(
                                        color: kPrimaryColor,
                                        onPressed: () async {
                                          // print(snapshot['Email'].toString());
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                ProgressDialog(
                                                    message: "Please wait..."),
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
                                                  butcher.email == null ||
                                                  auth.currentUser.email ==
                                                      null) {
                                                var snackBar = SnackBar(
                                                    content: Text(
                                                        "Details not correct"));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              } else {
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        'Booking Requests')
                                                    .add({
                                                  'Customer Name': name,
                                                  'Customer Address': address,
                                                  'Customer PhoneNo': phoneNo,
                                                  'user Email':
                                                      auth.currentUser.email,
                                                  'Butcher Name': butcher.name,
                                                  'Butcher PhoneNo':
                                                      butcher.phoneNo,
                                                  'Butcher Email':
                                                      butcher.email,
                                                  'Butcher Address':
                                                      butcher.address,
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
                                MaterialButton(
                                  onPressed: () {
                                    customLaunch('tel:${butcher.phoneNo}');
                                  },
                                  color: kPrimaryColor,
                                  child: Text('Call'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              MaterialButton(
                // style:ButtonStyle(
                //   backgroundColor: Colors.grey,
                // ),
                child: Row(
                  children: [
                    Icon(Icons.search, size: 15.0),
                    SizedBox(width: 10.0),
                    Text("Search By PhoneNo."),
                  ],
                ),
                onPressed: () => showSearch(
                  context: context,
                  delegate: SearchPage<Butcher>(
                    barTheme: ThemeData.dark(),
                    items: listButchers,
                    searchLabel: 'Search butcher by PhoneNo.',
                    suggestion: Center(
                      child: Text('Filter Butcher by phone'),
                    ),
                    failure: Center(
                      child: Text('No person found :('),
                    ),
                    filter: (person) => [
                      person.name,
                      person.city,
                      person.phoneNo.toString(),
                    ],
                    builder: (butcher) => Card(
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
                              image: butcher.userPhoto,
                              placeholder:
                                  'assets/images/Bubble-Loader-Icon.gif',
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
                                butcher.name.toUpperCase(),
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
                                child: Text(butcher.address,
                                    overflow: TextOverflow.ellipsis)),
                            Text(
                              butcher.overAllRating.substring(0, 3) + "🌟",
                              style: TextStyle(color: Colors.deepOrange),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Phone No: ${butcher.phoneNo}'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Rates for my work are following:'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Hen: ${butcher.henButcheringRate}'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                                'Goat or Lamb: ${butcher.goatLambButcheringRate}'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Cattle: ${butcher.cattleRate}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FutureBuilder(
                                    future: checkRequest(butcher.email),
                                    builder: (context, snapshotData) {
                                      // print("Bucking Email === > ${snapshotData.data}");

                                      return MaterialButton(
                                        color: kPrimaryColor,
                                        onPressed: () async {
                                          // print(snapshot['Email'].toString());
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                ProgressDialog(
                                                    message: "Please wait..."),
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
                                                  butcher.email == null ||
                                                  auth.currentUser.email ==
                                                      null) {
                                                var snackBar = SnackBar(
                                                    content: Text(
                                                        "Details not correct"));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              } else {
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        'Booking Requests')
                                                    .add({
                                                  'Customer Name': name,
                                                  'Customer Address': address,
                                                  'Customer PhoneNo': phoneNo,
                                                  'user Email':
                                                      auth.currentUser.email,
                                                  'Butcher Name': butcher.name,
                                                  'Butcher PhoneNo':
                                                      butcher.phoneNo,
                                                  'Butcher Email':
                                                      butcher.email,
                                                  'Butcher Address':
                                                      butcher.address,
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
                                MaterialButton(
                                  onPressed: () {
                                    customLaunch('tel:${butcher.phoneNo}');
                                  },
                                  color: kPrimaryColor,
                                  child: Text('Call'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              //               MaterialButton(

              //      child: Text("Search By City"),
              //  onPressed:()=>Navigator.of(context).push(
              //    MaterialPageRoute(
              //      builder: (context)=>
              //      AboutUs()
              //      )
              //      )

              // ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            availableButchers(),
            rejectedOrders(),
            acceptedOrders(),
          ],
        ),
      ),
    );
  }

  availableButchers() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Butchers').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return SpinKitRing(lineWidth: 5, color: Colors.blue);
        if (snapshot.data.docs.length == 0)
          return Center(
            child: Text(
              'No Butchers Yet',
            ),
          );
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return butcherList(snapshot.data.docs[index], index);
          },
        );
      },
    );
  }

  rejectedOrders() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Booking Requests')
          .where('user Email',
              isEqualTo: FirebaseAuth.instance.currentUser.email)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return SpinKitRing(lineWidth: 5, color: Colors.blue);
        if (snapshot.data.docs.length == 0)
          return Center(
            child: Text(
              'No Booking Requests',
            ),
          );
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return rejectedListCard(snapshot.data.docs[index]);
          },
        );
      },
    );
  }

  acceptedOrders() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Booking Requests')
          .where('user Email',
              isEqualTo: FirebaseAuth.instance.currentUser.email)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return SpinKitRing(lineWidth: 5, color: Colors.blue);
        if (snapshot.data.docs.length == 0)
          return Center(
            child: Text(
              'No Booking Requests',
            ),
          );
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return acceptedListCard(snapshot.data.docs[index]);
          },
        );
      },
    );
  }

  // acceptedOrders() {
  //   return Center(child: Text('Accepted Requests'));
  // }
}
