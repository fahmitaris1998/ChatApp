import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OtherMessage extends StatelessWidget {
  final String ms;
  final String time;

  const OtherMessage({Key key, this.ms, this.time}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width-80
          ),
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              )
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right:80.0,bottom: 5.0),
                child: Text(ms,style: TextStyle(fontSize: 17.0,color:Colors.black87),),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Text(DateFormat('HH:mm a').format(DateTime.now()),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          )),
                      SizedBox(width: 3.0),

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
