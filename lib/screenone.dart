import 'package:crud_firebase/screentwo.dart';
import 'package:flutter/material.dart';

class Screenone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, new MaterialPageRoute(
                builder: (context) => screentwo()
            ));
          },
        ),
        body: Container(
          child: Center(
            child:
            Text("Page 1", style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),
          ),
        ),
      ),
    );
  }
}
