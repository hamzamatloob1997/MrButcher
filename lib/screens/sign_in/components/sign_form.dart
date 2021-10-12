import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mr_butcher/components/custom_surfix_icon.dart';
import 'package:mr_butcher/components/form_error.dart';
import 'package:mr_butcher/screens/butcher_home/b_bottom_navigation.dart';
import 'package:mr_butcher/screens/forgot_password/forgot_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mr_butcher/screens/vendor_home/v_bottom_navigation.dart';
import 'package:mr_butcher/widgets/alert_dialog.dart';
import 'package:mr_butcher/widgets/loading_alert_dailog.dart';
import 'package:mr_butcher/widgets/snack_bar.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();

  String _role;

  final auth = FirebaseAuth.instance;
  User user;
  String email;
  String password;
  bool remember = false;

  final List<String> errors = [];

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
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
      DefaultButton(
        text: "Sign in",
        press: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            FirebaseFirestore.instance.collection('Users').doc(email).get().then((value) =>
            {
              _role = value['Role'],
            showLoadingDialog(context),
                signinUser(email, password, context),
            }).catchError((e){
              addError(error: "Please enter valid email");
            });
          }
        },
      ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        setState(() {
          if (value.isNotEmpty) {
            removeError(error: kPassNullError);
          } else if (value.length >= 8) {
            removeError(error: kShortPassError);
          }
          password = value;
        });
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        email = value;
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  Future signinUser(email, password, context) async {
    auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      if (value.user.emailVerified) {
        _role == "Vendor"
            ? Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => VendorBottomNavigation()),
                (Route<dynamic> route) => false)
            : Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => ButcherBottomNavigation()),
                (Route<dynamic> route) => false);
        // print(snapshot.data);
      } else {
        String title = "Email not verified";
        String content = "Please verify the Email first to SigIn.";
        verifyEmailDialog(context, title, content);
      }
    }).catchError((e) {
      Navigator.pop(context);
      Snack_Bar.show(context, e.message);
    });
  }
}
