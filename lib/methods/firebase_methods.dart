import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
String uid = auth.currentUser.uid.toString();
User user = auth.currentUser;
String role;

Future getRole(userEmail) async {
  DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('Users').doc(userEmail).get();
  role = snapshot['Role'];
  return role;
}
