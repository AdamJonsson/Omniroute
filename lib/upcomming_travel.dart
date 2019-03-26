import 'package:flutter/material.dart';
import 'package:omniroute/backend/travel_data.dart';

class UpcommingTravelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Omniroute'),
        elevation: 2.0,
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0).copyWith(top: 25.0),
        children: <Widget>[
          Card(
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Buss arrives within'),
                  TimeLeftCounter(
                    TravelDummyCreator.getTravelDummy()
                  ),
                ],
              ),
            ),
          ),
        ]
      ),
    );
  }
}


class TimeLeftCounter extends StatefulWidget {
  final Travel travel;
  TimeLeftCounter(this.travel);

  @override
  _TimeLeftCounterState createState() => _TimeLeftCounterState();
}

class _TimeLeftCounterState extends State<TimeLeftCounter> {
  int hour = 0;
  int minute = 0;
  int secounds = 0;

  @override
  void initState() {
    super.initState();
    this._updateTimeLeft();
  }

  void _updateTimeLeft() {
    var duration = widget.travel.durationUntilTravelBegin();
    this.hour = duration.inHours;
    this.minute = duration.inMinutes - duration.inHours * 60;
    this.secounds = duration.inSeconds - duration.inMinutes * 60;

    Future.delayed(Duration(seconds: 1)).then((_) {
      ///Check if this widget is not disposed 
      if(mounted) {
        this._updateTimeLeft();
        print(widget.travel.durationUntilTravelBegin().toString());
        setState(() {
          
        });
      }
    });
  }

  ///Adds a zero if the number is less than 10
  String _toTwoDigits(int number) {
    if(number < 10) {
      return "0" + number.toString();
    }
    return number.toString();
  }

  TextStyle _bigNumberStyle() {
    return TextStyle(
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _numberSplit() {
    return Container(
      width: 1.0,
      height: 10.0,
      color: Colors.grey[300],
      margin: EdgeInsets.only(left: 7.0, right: 7.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(this._toTwoDigits(this.hour), style: this._bigNumberStyle(),),
          _numberSplit(),
          Text(this._toTwoDigits(this.minute), style: this._bigNumberStyle(),),
          _numberSplit(),
          Text(
            this._toTwoDigits(this.secounds),
            style: TextStyle(
              fontSize: 40.0,
              fontStyle: FontStyle.italic,
              color: Colors.grey[300],
            ),
          ),
          Container(
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}