import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mr_butcher/components/custom_surfix_icon.dart';
// import 'package:mr_butcher/components/default_button.dart';
import 'package:mr_butcher/components/form_error.dart';
import 'package:mr_butcher/screens/vendor_home/v_bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class VCompleteProfileForm extends StatefulWidget {
  @override
  _VCompleteProfileFormState createState() => _VCompleteProfileFormState();
}

class _VCompleteProfileFormState extends State<VCompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];


  String name;
  String cnic;
  String address;
  String phoneNo;

  final auth = FirebaseAuth.instance;
  final email = FirebaseAuth.instance.currentUser.email;
  User user;

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  //End

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildCNICFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          ElevatedButton(

            child:Text("Continue"),
            onPressed: () async{
              if (_formKey.currentState.validate()) {
                try {
                  await FirebaseFirestore.instance.collection('Users').doc(email).update(
                      {
                      // FirebaseAuth.instance.currentUser.displayName: name,
                      'displayName': name,
                        'address': address,
                        // FirebaseAuth.instance.currentUser.phoneNumber: phoneNo,
                        'PhoneNumber': phoneNo,
                      });
                  await FirebaseFirestore.instance.collection('Vendors').doc(auth.currentUser.email).set({
                    'Name': name,
                    'CNIC': cnic,
                    'Address': address,
                    'PhoneNo': phoneNo,
                    'Email': FirebaseAuth.instance.currentUser.email,
                  });
                Navigator.pushNamed(context, VendorBottomNavigation.routeName);
                }
                catch (e){
                  print(e);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Container buildAddressFormField() {
    return Container(
      height: 150,
      child: TextFormField(
        expands: true,
        minLines: null,
        maxLines: null,
        keyboardType: TextInputType.streetAddress,
        onSaved: (newValue) => address = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kAddressNullError);
          }
          address = value;
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
          hintText: "Enter your Home address",
          // If  you are using latest version of flutter then label text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon:
              CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
        ),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      initialValue: '+92',
      maxLength: 13,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNo = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        phoneNo = value;
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
        hintText: "Enter your phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildCNICFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      maxLength: 13,
      onSaved: (newValue) => cnic = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCNICError);
        }
        cnic = value;
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
        hintText: "Enter your CNIC",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Question mark.svg"),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        name = value;
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
        hintText: "Enter your name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
