import 'package:flutter/material.dart';
import 'package:omniroute/main.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/map.png'
            )
          )
        ),
      )
    );
  }
}