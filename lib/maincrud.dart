import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/palette.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/scheduler.dart';

import 'daftar.dart';

class MainCrud extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Bisa niiiii', style: TextStyle(fontSize: 30.0),),
            ],
          ),
        ),
      ),
    );
  }
}
