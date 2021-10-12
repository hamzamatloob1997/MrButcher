import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:mr_butcher/models/progress_dialog.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';
import '../../../methods/firebase_methods.dart';

class ButcherHomePage extends StatefulWidget {
  static String routeName = '/driver_tracking_page';

  @override
  _ButcherHomePageState createState() => _ButcherHomePageState();
}

class _ButcherHomePageState extends State<ButcherHomePage> {
  String email;

  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print(' could not launch $command');
    }
  }

  butcherList(DocumentSnapshot snapshot) {
    print(snapshot.id.toString());

    if (snapshot['status'] == "pending") {
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
          title: Text(
              snapshot['Customer Name'] == null
                  ? "Name not correct"
                  : snapshot['Customer Name'].toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7))),
          subtitle: Text(snapshot['Customer Address'].toString()),
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Phone No: ${snapshot['Customer PhoneNo']}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                            .update({
                          'Customer Name': snapshot['Customer Name'],
                          'Customer Address': snapshot['Customer Address'],
                          'Customer PhoneNo': snapshot['Customer PhoneNo'],
                          'Butcher Email': snapshot['Butcher Email'],
                          'user Email': snapshot['user Email'],
                          'status': "started"
                        }).then((value) {
                          setState(() {});
                        });
                      } catch (e) {
                        print(e);
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Accept",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  // child: Text('Accept'),
                  // ),
                ),

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
                            .update({
                          'Customer Name': snapshot['Customer Name'],
                          'Customer Address': snapshot['Customer Address'],
                          'Customer PhoneNo': snapshot['Customer PhoneNo'],
                          'Butcher Email': snapshot['Butcher Email'],
                          'user Email': snapshot['user Email'],
                          'status': "rejected"
                        }).then((value) {
                          setState(() {});
                        });
                      } catch (e) {
                        print(e);
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Reject",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  // child: Text('Accept'),
                  // ),
                ),
                //                Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 20),
                // ),

                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: MaterialButton(
                    onPressed: () {
                      customLaunch('tel:${snapshot['Customer PhoneNo']}');
                    },
                    color: kPrimaryColor,
                    child: Text('Call', style: TextStyle(color: Colors.white)),
                  ),
                ),
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

  onGoingbutcherList(DocumentSnapshot snapshot) {
    if (snapshot['status'] == "started") {
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
          title: Text(
              snapshot['Customer Name'] == null
                  ? "Name not correct"
                  : snapshot['Customer Name'].toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7))),
          subtitle: Text(snapshot['Customer Address'].toString()),
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Phone No: ${snapshot['Customer PhoneNo']}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: MaterialButton(
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
                            .update({
                          'Customer Name': snapshot['Customer Name'],
                          'Customer Address': snapshot['Customer Address'],
                          'Customer PhoneNo': snapshot['Customer PhoneNo'],
                          'Butcher Email': snapshot['Butcher Email'],
                          'user Email': snapshot['user Email'],
                          'status': "completed"
                        }).then((value) {
                          setState(() {});
                        });
                      } catch (e) {
                        print(e);
                      }
                      Navigator.pop(context);
                    },
                    color: kPrimaryColor,
                    child:
                        Text('Deliver', style: TextStyle(color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: MaterialButton(
                    onPressed: () {
                      customLaunch('tel:${snapshot['Customer PhoneNo']}');
                    },
                    color: kPrimaryColor,
                    child: Text('Call', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: SizedBox(), //No Bookings Request Found
      );
    }
  }

  onCompletedbutcherList(DocumentSnapshot snapshot) {
    if (snapshot['status'] == "completed") {
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
          title: Text(
              "${snapshot['Customer Name']}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7))),
          subtitle: Text("${snapshot['Customer Address'] }"),
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Phone No: ${snapshot['Customer PhoneNo']}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: MaterialButton(
                    onPressed: null,
                    color: kPrimaryColor,
                    child: Text('Delivered'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: MaterialButton(
                    onPressed: () {
                      customLaunch('tel:${snapshot['Customer PhoneNo']}');
                    },
                    color: kPrimaryColor,
                    child: Text('Call', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            (snapshot['status'] == "completed" && snapshot['rating'] != "0")
                ? SmoothStarRating(
                    allowHalfRating: false,
                    onRated: (v) {
                      print("$v");
                    },
                    starCount: int.parse(snapshot['rating']),
                    rating: double.parse(snapshot['rating']),
                    size: 40.0,
                    isReadOnly: true,
                    // fullRatedIconData: Icons.blur_off,
                    // halfRatedIconData: Icons.blur_on,
                    color: Colors.green,
                    borderColor: Colors.green,
                    spacing: 0.0)
                : SizedBox()
          ],
        ),
      );
    } else {
      return Center(
        child: SizedBox(), //No Bookings Request Found
      );
    }
  }

// var locationMessage ="";

  void getCurrentLocation() async {
    // var position = await Geolocator().
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
// Position lastPosition = await Geolocator.getLastKnownPosition();

// print(position.toString());

// var lat2 =34.1023;
// var long2 = 71.4804;

// var lat3=31.4024;
// var long3 = 76.1151;
    FirebaseFirestore.instance
        .collection("Butchers")
        .doc(auth.currentUser.email)
        .update(
            {"BLatitude": position.latitude, "BLongitude": position.longitude});
// var distance = Geolocator.distanceBetween(position.latitude, position.longitude, lat3, long3);
// print("Mathra Distance# $distance");
// setState(() {
    // locationMessage = "$position.latitude , $position.longitude";
// });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                icon: Icon(Icons.location_on),
                onPressed: () {
                  // print("Location Icon");
                  getCurrentLocation();
                })
          ],
          backgroundColor: hexColor,
          bottom: TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: "Booking Requests"),
                Tab(text: "Ongoing Orders"),
                Tab(text: "Completed"),
              ]),
        ),
        body: TabBarView(
          children: [
            bookingRequests(),
            onGoingOrders(),
            completedOrders(),
          ],
        ),
      ),
    );
  }

  bookingRequests() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Booking Requests')
          .where('Butcher Email',
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
            return butcherList(snapshot.data.docs[index]);
          },
        );
      },
    );
  }

  onGoingOrders() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Booking Requests')
          .where('Butcher Email',
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
            return onGoingbutcherList(snapshot.data.docs[index]);
          },
        );
      },
    );

    // return Center(child: Text("onGoing Bookings"),);
  }

  completedOrders() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Booking Requests')
          .where('Butcher Email',
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
            return onCompletedbutcherList(snapshot.data.docs[index]);
          },
        );
      },
    );

    // return Center(child: Text("onGoing Bookings"),);
  }

  // completedOrders() {
  //   return Center(
  //     child: Text("Completed Orders"),
  //   );
  // }
}
