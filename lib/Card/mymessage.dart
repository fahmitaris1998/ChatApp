import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyMessage extends StatelessWidget {
  final String ms;

  const MyMessage({Key key, this.ms}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width-80,
            ),
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                )
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right:80.0,bottom: 5.0),
                  child: Text(ms,style: TextStyle(fontSize: 17.0,color:Colors.white),),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      children: [
                        Text(DateFormat('HH:mm a').format(DateTime.now()),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            )),
                        SizedBox(width: 3.0),
                        Icon(
                          Icons.done_all,
                          size: 18.0,
                          color: Colors.white,
                        )
                      ],
                    )
                )
              ],
            )
        ),
      ],
    );
  }
}