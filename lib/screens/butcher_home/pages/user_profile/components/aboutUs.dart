import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mr_butcher/size_config.dart';

class AboutUs extends StatefulWidget {
  static String routeName = "/parent_about";

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  String storeName;
  String storeCnic;
  String storeAddress;
  String storePhoneNo;

  String name;
  String cnic;
  String address;
  String phoneNo;

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Help Center",
          style: TextStyle(
            color: Color(0XFF8B8B8B),
          ),
        ),
        elevation: 2,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About",
                        style: TextStyle(
                            color: Color(0XFF000000),
                            fontWeight: FontWeight.w900),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.favorite,
                        ),
                        title: Text(
                          "Mr Butcher by Jahan Zeb",
                          style: TextStyle(
                            color: Color(0XFF8B8B8B),
                          ),
                        ),
                      ),
                      Divider(
                        indent: 3.0,
                      ),
                      ListTile(
                        leading: Icon(CupertinoIcons.globe),
                        title: Text(
                          "https://mrbutcher.com",
                          style: TextStyle(
                            color: Color(0XFF8B8B8B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Follow me to stay updated",
                        style: TextStyle(
                            color: Color(0XFF000000),
                            fontWeight: FontWeight.w900),
                      ),
                      ListTile(
                        leading: Icon(
                         Entypo.facebook
                        ),
                        title: Text(
                          "https://fb.com/jahanzeb",
                          style: TextStyle(
                            color: Color(0XFF8B8B8B),
                          ),
                        ),
                      ),
                      Divider(
                        indent: 3.0,
                      ),
                      ListTile(
                        leading: Icon(Entypo.twitter),
                        title: Text(
                          "https://t.com/jahanzeb",
                          style: TextStyle(
                            color: Color(0XFF8B8B8B),
                          ),
                        ),
                      ),

                      
                    ],
                  ),
                ),
              ),

            Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Version",
                        style: TextStyle(
                            color: Color(0XFF000000),
                            fontWeight: FontWeight.w900),
                      ),
                      ListTile(
                        leading: Icon(
                        Octicons.versions
                        ),
                        title: Text(
                          "V 1.00",
                          style: TextStyle(
                            color: Color(0XFF8B8B8B),
                          ),
                        ),
                      ),
                    

                      
                    ],
                  ),
                ),
              ),

            ] 
      
    ))));
  }
}
