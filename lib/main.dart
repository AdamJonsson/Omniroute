import 'package:flutter/material.dart';
import 'package:omniroute/upcomming_travel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Colors.grey[200],
        canvasColor: Colors.grey[200],
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          elevation: 0.0,
        ),
        primarySwatch: Colors.brown,
      ),
      home: UpcommingTravelPage()
    );
  }
}