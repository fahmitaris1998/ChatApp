import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/palette.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
      ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage('https://image.tmdb.org/t/p/w235_and_h235_face/lldeQ91GwIVff43JBrpdbAAeYWj.jpg'),
            ),
            SizedBox(width: 20.0,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("#1 Kecanduan",maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black, fontSize: 18.0),),
                  SizedBox(height: 5.0,),
                  Text("Wrap children of Row with an Expanded or Flexible widget. You can use either of them, both have their advantages",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey, fontSize: 15.0),),
                ],
              ),
            )
          ],
        ),

    );
  }
}
