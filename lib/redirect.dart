import 'package:crud_firebase/screenone.dart';
import 'package:crud_firebase/screentwo.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp() ,
  ),
  );
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Screenone();
  }
}
