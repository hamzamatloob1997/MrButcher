import 'package:flutter/material.dart';

class CircularProgressIndicatorApp extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return CircularProgressIndicator(  
      strokeWidth: 8,
      semanticsLabel: 'Verifying',
      );  
  }  
} 