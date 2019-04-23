import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omniroute/backend/travel_data.dart';
import 'package:omniroute/map.dart';
import 'package:omniroute/time_list.dart';

class UpcommingTravelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Omniroute'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return TimeList();
                }
              ));
            },
            icon: Icon(Icons.timelapse),
          )
        ],
        elevation: 2.0,
      ),
      body: TimeLine(),
    );
  }
}


class TimeLine extends StatefulWidget {
  final lineMargin = EdgeInsets.only(left: 10);

  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  Travel travelDummy;
  List<Station> stations;

  @override
  void initState() {
    super.initState();
    travelDummy =  TravelDummyCreator.getTravelDummy();
    stations = TravelDummyCreator.createStations();
    _updateLoop();
  }


  void _updateLoop() {
    Future.delayed(Duration(seconds: 1)).then((_) {
      setState(() {
        
      });
      _updateLoop();
    });
  }


  ///Getting the selected station
  Station _getSelectedStation() {
    for(var station in stations) {
      if(station.isSelectedStation) {
        return station;
      }
    }
    return null;
  }


  Station _getStationBusIsAt() {
    for(var station in stations) {
      if(_busAtStation(station)) {
        return station;
      }
    }
    return null;
  }


  List<Widget> _generateTimeline() {
    List<Widget> timelineCards = [];
    bool bussCardAdded = false;
    stations.forEach((station) {

      //Adding the bus at the right place
      if(station.isUpcomming() == true && !bussCardAdded) {
        var selectedStation = _getSelectedStation();
        var targetIsWork = false;
        if(!selectedStation.isUpcomming()) {
          selectedStation = stations.last;
          targetIsWork = true;
        }
        timelineCards.add(BussCard(
          selectedStation.timeWhenBussArive,
          targetIsWork,
          _getStationBusIsAt()
        ));
        bussCardAdded = true;
      }

      timelineCards.add(
        TimeLineCard(
          key: Key(station.name),
          expanded: !_busAtStation(station),
          isUpcomming: station.isUpcomming(),
          isLastEvent: station.isWork,
          importantLevel: station.isWork || station.isSelectedStation ? 4 : 0,
          cardContent: ListTile(
            title: Text(station.name),
            subtitle: Text(DateFormat.Hms().format(station.timeWhenBussArive).toString() + ' kl'),
            trailing: IconButton(
              onPressed: () {
                
              },
              icon: Icon(Icons.location_on)
            )
          ),
          onLine: _buildOnlineWidget(station),
        )
      );
    });

    return timelineCards;
  }


  ///If the bus is at the station
  bool _busAtStation(Station station) {
    var timeDiff = station.timeWhenBussArive.difference(DateTime.now()).inSeconds.abs();
    return timeDiff < 5;
  }


  Widget _buildOnlineWidget(Station station) {
    if(station.isSelectedStation) {
      return TimelineIcon(
        Icons.home,
        station.isUpcomming() ? Colors.grey : Theme.of(context).primaryColor
      );
    }
    else if(station.isWork) {
      return TimelineIcon(
        Icons.work,
        Colors.grey
      );
    }
    
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 50.0),
      children: _generateTimeline()
    );
  }
}


///The bus cards
class BussCard extends StatefulWidget {
  final bool isWork;
  final Station stationAt;
  final DateTime selectedStationTime;
  BussCard(this.selectedStationTime, this.isWork, this.stationAt);

  @override
  _BussCardState createState() => _BussCardState();
}

class _BussCardState extends State<BussCard> with SingleTickerProviderStateMixin {
  AnimationController _collapseController;
  Animation<double> _collapseAnimation;

  @override
  void initState() {
    super.initState();
    _collapseController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    if(widget.stationAt != null) {
      _collapseController.value = 1.0;
    }
    _collapseAnimation = CurvedAnimation(
      parent: _collapseController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(BussCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.stationAt != null) {
      _collapseController.forward();
    }
    else {
      _collapseController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TimelineLine(
      isLastEvent: false,
      isUpcomming: false,
      importantLevel: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.isWork ? 'At your work in' : 'At your station in',
                  style: Theme.of(context).textTheme.subhead,
                ),
                TimeLeftCounter(
                  widget.selectedStationTime
                ),
              ],
            ),
          ),
          Container(
            child: SizeTransition(
              sizeFactor: _collapseAnimation,
              axis: Axis.vertical,
              axisAlignment: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.brown.withAlpha(25),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                ),
                child: ListTile(
                  onTap: () {
                    
                  },
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                    ],
                  ),
                  title: Text(widget.stationAt != null ? widget.stationAt.name : ''),
                  subtitle: Text('Currently at this station'),
                ),
              ),
            ),
          )
        ],
      ),
      onLine: TimelineIcon(
        Icons.directions_bus,
        Theme.of(context).primaryColor
      ),
      isCurrentEvent: true,
    );
  }
}


///A basic icon container for the timeline
class TimelineIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  TimelineIcon(this.icon, this.backgroundColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor
      ),
      child: Icon(icon, color: Colors.white,),
    );
  }
}


///The defualt card for a timeline section
class TimeLineCard extends StatefulWidget {
  ///The info of this TimeLineCard
  final Widget cardContent;

  ///The widget on the line beside the card
  final Widget onLine;

  ///If this widget is an upcomming event or not (make the timeline gray)
  final bool isUpcomming;

  ///If the timeline is the current event
  final bool isCurrentEvent;

  ///If this is the last event
  final bool isLastEvent;

  ///How important this event is, 0 = not important, 5 = very important
  final int importantLevel;

  final bool expanded;

  TimeLineCard({Key key, @required this.cardContent, this.onLine ,this.isUpcomming = false, this.isCurrentEvent = false, this.isLastEvent = false, this.importantLevel = 0, this.expanded = true}) : super(key: key);

  @override
  _TimeLineCardState createState() => _TimeLineCardState();
}

class _TimeLineCardState extends State<TimeLineCard> with SingleTickerProviderStateMixin{


  AnimationController _controller;
  Animation _cardSizeAnimation;
  Animation _lineHeightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    if(widget.expanded) {
      _controller.value = 1.0;
    }

    _cardSizeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.5, 1, curve: Curves.easeInOut)
    );

    _lineHeightAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.5, curve: Curves.easeInOut)
    );
  }


  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.expanded) {
      _controller.forward();
    }
    else {
      _controller.reverse();
    }
  }


  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _lineHeightAnimation,
      child: TimelineLine(
        isCurrentEvent: widget.isCurrentEvent,
        isLastEvent: widget.isLastEvent,
        isUpcomming: widget.isUpcomming,
        importantLevel: widget.importantLevel,
        onLine: widget.onLine,
        child: SizeTransition(
          axisAlignment: -1.0,
          sizeFactor: _cardSizeAnimation,
          axis: Axis.horizontal,
          child: widget.cardContent,
        ),
      )
    );
  }
}


class TimelineLine extends StatelessWidget {
  final Widget child;

  ///The widget on the line beside the card
  final Widget onLine;

  ///If this widget is an upcomming event or not (make the timeline gray)
  final bool isUpcomming;

  ///If the timeline is the current event
  final bool isCurrentEvent;

  ///If this is the last event
  final bool isLastEvent;

  final int importantLevel;

  TimelineLine({@required this.child, @required this.onLine, @required this.isUpcomming, @required this.isCurrentEvent, @required this.isLastEvent, this.importantLevel = 0});

  Widget _buildLineIcon(BuildContext context) {

    //Check if we got an custom online widget
    if(onLine != null) {
      return onLine;
    }

    //The defualt online widget
    return Center(
      child: Container(
        width: 25.0,
        height: 25.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isUpcomming ? Colors.grey[200] : Theme.of(context).primaryColor,
          border: Border.all(
            width: 5.0,
            color: _getLineColor(context)
          )
        ),
      ),
    );
  }

  ///Getting the color for the line
  Color _getLineColor(BuildContext context) {
    if(isUpcomming) {
      return Colors.grey;
    }

    return Theme.of(context).primaryColor;
  }

  ///Builds a line part
  Widget _buildLinePart(BuildContext context, Color color) {
    return Expanded(
      child: Container(
        width: 5.0,
        color: color
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 2.0),
            width: 35.0,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        _buildLinePart(
                          context,
                          _getLineColor(context)
                        ),
                        Builder(
                          builder: (context) {
                            if(isLastEvent) {
                              return Expanded(
                                child: Container(),
                              );
                            }
                            return _buildLinePart(
                              context,
                              isCurrentEvent ? Colors.grey : _getLineColor(context)
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: _buildLineIcon(context),
                )
              ],
            )
          ),
          Container(
            width: 10.0,
            height: 2.0,
            color: _getLineColor(context)
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 2.0),
              child: Card(
                elevation: importantLevel.toDouble(),
                child: child
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class TimeLeftCounter extends StatefulWidget {
  final DateTime selectedTime;
  TimeLeftCounter(this.selectedTime);

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
    var duration = widget.selectedTime.difference(DateTime.now());
    this.hour = duration.inHours;
    this.minute = duration.inMinutes - duration.inHours * 60;
    this.secounds = duration.inSeconds - duration.inMinutes * 60;

    Future.delayed(Duration(seconds: 1)).then((_) {
      ///Check if this widget is not disposed 
      if(mounted) {
        this._updateTimeLeft();
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

  TextStyle _bigNumberStyle(BuildContext context) {
    return TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).primaryColor
    );
  }

  Widget _numberSplit() {
    return Container(
      width: 1.0,
      height: 15.0,
      color: Colors.grey[300],
      margin: EdgeInsets.only(left: 7.0, right: 7.0, top: 10.0),
    );
  }

  Widget _numberData({@required Widget number, @required String data}) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          number,
          Text(
            data,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10.0
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _numberData(
            data: 'Hour',
            number: Text(this._toTwoDigits(this.hour), style: this._bigNumberStyle(context),),
          ),
          _numberSplit(),
          _numberData(
            data: 'Minute',
            number: Text(this._toTwoDigits(this.minute), style: this._bigNumberStyle(context),),
          ),
          _numberSplit(),
          _numberData(
            data: 'Secound',
            number: Text(
              this._toTwoDigits(this.secounds),
              style: TextStyle(
                fontSize: 30.0,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).primaryColor
              ),
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
