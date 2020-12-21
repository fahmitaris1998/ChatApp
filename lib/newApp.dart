import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';


class NewApp extends StatefulWidget {
  @override
  _NewAppState createState() => _NewAppState();
}

class _NewAppState extends State<NewApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("New App"),
        ),
        body:Center(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Swiper(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index){
                return Container(
                  color: Colors.amber
                );
              },
              viewportFraction: 0.8,
              scale: 0.9,
              layout: SwiperLayout.STACK,
              itemWidth: 300.0,
              control: SwiperControl(),
              pagination: SwiperPagination(),
            )
          ),
        ) ,
      ),
    );
  }
}
