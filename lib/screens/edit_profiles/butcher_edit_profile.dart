import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mr_butcher/components/custom_surfix_icon.dart';
import 'package:mr_butcher/components/default_button.dart';
import 'package:mr_butcher/components/form_error.dart';
import 'package:mr_butcher/size_config.dart';
import 'package:mr_butcher/widgets/loading_alert_dailog.dart';
import 'package:mr_butcher/widgets/snack_bar.dart';
import '../../constants.dart';

class DriverEditProfile extends StatefulWidget {
  static String routeName = "/driver_edit_profile";

  @override
  _DriverEditProfileState createState() => _DriverEditProfileState();
}

class _DriverEditProfileState extends State<DriverEditProfile> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  String storeName;
  String storeCnic;
  String storeAddress;
  String storePhoneNo;
  String storeCattleRate;
  String storeGoatLambButcheringRate;
  String storeHenButcheringRate;

  String name;
  String cnic;
  String address;
  String phoneNo;
  String henButcheringRate;
  String goatLambButcheringRate;
  String cattleRate;

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
            "Edit Profile",
            style: TextStyle(
              color: Color(0XFF8B8B8B),
            ),
          ),
          elevation: 2,
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Butchers')
              .doc(FirebaseAuth.instance.currentUser.email)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null)
              return SpinKitCircle(color: kPrimaryColor,);
            storeName = snapshot.data['Name'];
            storeCnic = snapshot.data['CNIC'];
            storePhoneNo = snapshot.data['PhoneNo'];
            storeAddress = snapshot.data['Address'];
            storeHenButcheringRate = snapshot.data['HenButcheringRate'];
            storeGoatLambButcheringRate = snapshot.data['GoatLambButcheringRate'];
            storeCattleRate = snapshot.data['CattleRate'];
            return SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(height: SizeConfig.screenHeight * 0.03),
                          Text(
                            "You can edit your profile here!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          buildNameFormField(),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          buildCNICFormField(),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          buildPhoneNumberFormField(),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          cattleRateFormField(),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          goatLambRateFormField(),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          henRateFormField(),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          buildAddressFormField(),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          FormError(errors: errors),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          DefaultButton(
                            text: "Update",
                            press: () async {
                              if (_formKey.currentState.validate()) {
                                if (name == null) {
                                  name = storeName;
                                }
                                if (address == null) {
                                  address = storeAddress;
                                }
                                if (phoneNo == null) {
                                  phoneNo = storePhoneNo;
                                }
                                if (cnic == null) {
                                  cnic = storeCnic;
                                }
                                if (cattleRate == null) {
                                  cattleRate =
                                      storeCattleRate;
                                }
                                if (goatLambButcheringRate == null) {
                                  goatLambButcheringRate =
                                      storeGoatLambButcheringRate;
                                }
                                if (henButcheringRate == null) {
                                  henButcheringRate =
                                      storeHenButcheringRate;
                                }
                                showLoadingDialog(context);
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('Butchers')
                                      .doc(FirebaseAuth
                                          .instance.currentUser.email)
                                      .update({
                                    'Name': name,
                                    'CNIC': cnic,
                                    'Address': address,
                                    'PhoneNo': phoneNo,
                                    'HenButcheringRate': henButcheringRate,
                                    'GoatLambButcheringRate': goatLambButcheringRate,
                                    'CattleRate': cattleRate,
                                  }).then((value) => {
                                    Navigator.pop(context),
                                    Snack_Bar.show(context, "Profile Updated Successfully!")
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  Container buildAddressFormField() {
    return Container(
      height: 150,
      child: TextFormField(
        expands: true,
        minLines: null,
        maxLines: null,
        initialValue: storeAddress,
        keyboardType: TextInputType.streetAddress,
        onSaved: (newValue) => address = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kAddressNullError);
            address = value;
          }
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: kAddressNullError);
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Address",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon:
              CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
        ),
      ),
    );
  }

  TextFormField cattleRateFormField() {
    return TextFormField(
      initialValue: storeCattleRate,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => cattleRate = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kDrivingLicenseNumberError);
        }
        cattleRate = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kDrivingLicenseNumberError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Cattle Rate",
        hintText: "Enter your rate for Cattle",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/driving-license.svg"),
      ),
    );
  }

  TextFormField goatLambRateFormField() {
    return TextFormField(
      initialValue: storeGoatLambButcheringRate,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => goatLambButcheringRate = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNumberPlateError);
        }
        goatLambButcheringRate = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNumberPlateError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Goat or Lamb Rate",
        hintText: "Enter your rate for Goat or Lamb",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/license-plate.svg"),
      ),
    );
  }

  TextFormField henRateFormField() {
    return TextFormField(
      initialValue: storeHenButcheringRate,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => henButcheringRate = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kRegistrationError);
        }
        henButcheringRate = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kRegistrationError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Hen Rate",
        hintText: "Enter your rate for Hen",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/van.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      initialValue: storePhoneNo,
      maxLength: 13,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNo = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
          phoneNo = value;
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildCNICFormField() {
    return TextFormField(
      initialValue: storeCnic,
      maxLength: 13,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => cnic = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCNICError);
          cnic = value;
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kCNICError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "CNIC",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/card.svg"),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      initialValue: storeName,
      keyboardType: TextInputType.name,
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
          name = value;
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}