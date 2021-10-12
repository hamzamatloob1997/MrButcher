import "package:flutter/material.dart";
import 'package:mr_butcher/models/verify_email.dart';

showAlertDialog(BuildContext context, title, content) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("Ok"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

verifyEmailDialog(BuildContext context, title, content) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("Verify"),
    onPressed: () {
      Navigator.pushReplacementNamed(context, VerifyEmail.routeName);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
