import 'package:flutter/material.dart';
import 'package:omniroute/main.dart';

class TimeList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar,
      body: ListView.builder(
        itemBuilder: (context, index) {
          return TimeCard();
        },
      )
    );
  }
}

class TimeCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('17:30'),
        isThreeLine: true,
        subtitle: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('19-05-06, tisdag'),
              ],
            )
          ],
        )
      )
    );
  }
}

//Datum och vecka
//Station
//Hemmet