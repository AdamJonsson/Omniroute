import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:omniroute/backend/travel_data.dart';
import 'package:omniroute/map.dart';
import 'package:omniroute/scrollable_sheet.dart';
import 'package:omniroute/time_list.dart';

class UpcommingTravelPage extends StatefulWidget {
  @override
  _UpcommingTravelPageState createState() => _UpcommingTravelPageState();
}

class _UpcommingTravelPageState extends State<UpcommingTravelPage> {
  List<Station> _stations;
  Station _focusStation;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _stations = TravelDummyCreator.createStations();
  }

  void _expandMap() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.bounceOut
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timeline'),
        actions: <Widget>[
          // IconButton(
          //   onPressed: () {
          //     Navigator.push(context, MaterialPageRoute(
          //       builder: (context) {
          //         return TimeList();
          //       }
          //     ));
          //   },
          //   icon: Icon(Icons.timelapse),
          // )
        ],
        elevation: 2.0,
      ),
      body: ScrollableSheet(
        scrollController: _scrollController,
        constrainSheetChild: true,
        minSheetHeight: 0.05,
        maxSheetHeight: 0.7,
        sheetStops: [0.0, 0.5, 1.0],
        child: TimeLine(
          stations: _stations,
          onStationLocationButton: (station) {
            if(_scrollController != null) {
              _expandMap();
            }
            setState(() {
              _focusStation = station;
            });
          },
        ),
        sheetChild: StationMap(
          _stations,
          _focusStation, 
          () {
            _expandMap();
          },
        )
      )
          // return CustomScrollView(
          //   controller: _scrollController,
          //   slivers: <Widget>[
          //     SliverPersistentHeader(
          //       delegate: TimlineContainerDelegate(
          //         viewportHeight: constrains.maxHeight,
          //         child: TimeLine(
          //           stations: _stations,
          //           onStationLocationButton: (station) {
          //             if(_scrollController != null) {
          //               _expandMap();
          //             }
          //             setState(() {
          //               _focusStation = station;
          //             });
          //           },
          //         ),
          //       ),
          //     ),
          //     SliverToBoxAdapter(
          //       child: StationMap(
          //         constrains.maxHeight, 
          //         _stations,
          //         _focusStation, 
          //         () {
          //           _expandMap();
          //         },
          //       ),
          //     ),
          //   ],
          // );
    );
  }
}


class StationMap extends StatefulWidget {
  final List<Station> stations;
  final Station focusStation;
  final VoidCallback onTopDrawerClick;
  StationMap(this.stations, this.focusStation, this.onTopDrawerClick);

  @override
  _StationMapState createState() => _StationMapState();
}

class _StationMapState extends State<StationMap> {

  GoogleMapController _mapController;
  Set<Polyline> lines = {};

  ///All the coordinates that the bus has to drive
  List<LatLng> _currentBusLine;
  LatLng _busPosition;

  BitmapDescriptor _stationMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _busMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _stationMarkerFull = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    _createRoute();
    _updateNextStationLoop();

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(1.0, 1.0), ), 'assets/markers/icon_hollow.png').then((icon) {
      setState(() {
        _stationMarker = icon;
      });
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(1.0, 1.0), ), 'assets/markers/bus.png').then((icon) {
      setState(() {
        _busMarker = icon;
      });
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(1.0, 1.0), ), 'assets/markers/icon_full.png').then((icon) {
      setState(() {
        _stationMarkerFull = icon;
      });
    });
  }

  ///Updates every time the bus arrives at a new
  ///station
  void _updateNextStationLoop() {
    var nextStation = StationData.getNextStation(widget.stations);
    Future.delayed(nextStation.durationUntilBuss()).then((_) {
      _createRoute();
      setState(() {
      });
      _updateNextStationLoop();
    });
  }

  void _createRoute() {
    var routes = TravelDummyCreator.getRoutes();
    lines = {};
    for (var route in routes) {
      List<LatLng> coords = [];
      for(var coord in route['coords'][1]) {
        coords.add(LatLng(coord[1], coord[0]));
      }

      var isNextStation = _isNextStation(route['to']);
      if(isNextStation) {
        _currentBusLine = coords.toList();
      }
      lines.add(Polyline(
        polylineId: PolylineId(route['from']),
        points: coords,
        zIndex: isNextStation ? 1 : 0,
        color: isNextStation ? Colors.tealAccent : Colors.teal,
        width: isNextStation ? 4 : 2
      ));
    }

    var nextStation = StationData.getNextStation(widget.stations);
    _updateBusPosition(
      Duration(milliseconds: (nextStation.durationUntilBuss().inMilliseconds / _currentBusLine.length).floor())
    );
  }

  void _updateBusPosition(Duration updateInterval) {
    if(_currentBusLine.length > 0) {
      _busPosition = _currentBusLine.removeAt(0);
      Future.delayed(updateInterval).then((_) {
        _updateBusPosition(updateInterval);
        setState(() {
          
        });
      });
    }
  }

  Set<Marker> _generateMarkers() {
    Set<Marker> markers;
    markers = widget.stations.map((station) {
      return Marker(
        markerId: MarkerId(station.name),
        position: station.coordinates,
        infoWindow: InfoWindow(
          title: station.name
        ),
        icon: station.isUpcomming() ? _stationMarker : _stationMarkerFull
      );
    }).toSet();

    markers.add(Marker(
      markerId: MarkerId('Buss'),
      position: _busPosition,
      anchor: Offset(0.5, 0.5),
      infoWindow: InfoWindow(
        title: 'Bussen'
      ),
      icon: _busMarker
    ));

    return markers;
  }

  ///Check if the next station has the name given
  bool _isNextStation(String name) {
    return StationData.getNextStation(widget.stations).name == name;
  }

  @override
  void didUpdateWidget(StationMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(_mapController != null && widget.focusStation != null) {
      _mapController.animateCamera(CameraUpdate.newLatLng(
        widget.focusStation.coordinates
      ));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            child: GoogleMap(
              myLocationEnabled: true,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              gestureRecognizers: Set()
                ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer())),
              initialCameraPosition: CameraPosition(
                target: LatLng(59.3428, 18.0485),
                zoom: 16.0
              ),
              polylines: lines,
              markers: _generateMarkers(),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.white.withOpacity(0.0)],
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter,
                )
              ),
            )
          ),
          Positioned(
            bottom: 115.0,
            right: 10.0,
            child: Material(
              elevation: 3.0,
              shape: CircleBorder(),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: IconButton(
                  onPressed: () {
                    _mapController.moveCamera(CameraUpdate.newLatLng(_busPosition));
                  },
                  icon: Icon(Icons.directions_bus, color: Colors.grey[700],),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class TimlineContainerDelegate extends SliverPersistentHeaderDelegate {
  
  final Widget child;
  final double viewportHeight;

  TimlineContainerDelegate({this.child, this.viewportHeight});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return this.child;
  }

  @override
  double get maxExtent => this.viewportHeight * 0.9;

  @override
  double get minExtent => this.viewportHeight * 0.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

}


class TimeLine extends StatefulWidget {
  final List<Station> stations;
  final lineMargin = EdgeInsets.only(left: 10);
  final Function(Station) onStationLocationButton;
  TimeLine({@required this.onStationLocationButton, @required this.stations});

  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {

  @override
  void initState() {
    super.initState();
    _updateLoop();
  }


  void _updateLoop() {
    Future.delayed(Duration(seconds: 4)).then((_) {
      setState(() {
        
      });
      _updateLoop();
    });
  }


  ///Selects a station 
  void _selectStation(Station station) {
    widget.stations.forEach((station) {
      station.isSelectedStation = false;
    });
    setState(() {
      station.isSelectedStation = true;
    });
  }


  List<Widget> _generateTimeline() {
    List<Widget> timelineCards = [];
    bool bussCardAdded = false;
    widget.stations.forEach((station) {

      //Adding the bus at the right place
      if(station.isUpcomming() == true && !bussCardAdded) {
        var selectedStation = StationData.getSelectedStation(widget.stations);
        var targetIsWork = false;
        if(!selectedStation.isUpcomming()) {
          selectedStation = widget.stations.last;
          targetIsWork = true;
        }
        timelineCards.add(BussCard(
          selectedStation,
          targetIsWork,
          StationData.getStationBusIsAt(widget.stations),
        ));
        bussCardAdded = true;
      }

      timelineCards.add(
        TimeLineCard(
          key: Key(station.name),
          expanded: !StationData.isBusAtStation(station),
          isUpcomming: station.isUpcomming(),
          isLastEvent: station.isWork,
          importantLevel: station.isWork || station.isSelectedStation ? 4 : 0,
          cardContent: ListTile(
            title: Row(
              children: <Widget>[
                Text(
                  DateFormat.Hm().format(station.timeWhenBussArive).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5.0,),
                Text(station.name)
              ],
            ),
            subtitle: Builder(builder: (context) {
              if(!station.isUpcomming()) {
                return Text('Bus already arrived');
              }
              return Text(DateFormat.Hms().format(station.timeWhenBussArive).toString() + ' kl');
            },),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Builder(builder: (context) {
                  if(station.isWork) {
                    return Container();
                  }
                  else {
                    return PopupMenuButton(
                      child: Icon(Icons.more_horiz),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                        PopupMenuItem<int>(
                          value: 1,
                          child: IconRowButton(icon: Icons.directions_run, text: 'Select as pickup station',)
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: IconRowButton(icon: Icons.location_on, text: 'See location',)
                        ),
                        PopupMenuItem<int>(
                          enabled: station.isUpcomming(),
                          value: 3,
                          child: IconRowButton(icon: Icons.notifications, text: 'Notify when bus arrives',)
                        ),
                      ],
                      onSelected: (value) {
                        switch(value) {
                          case 1:
                            _selectStation(station);
                            break;
                          case 2:
                            widget.onStationLocationButton(station);
                            break;
                          case 3:
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('You will be notified when bus arrives at'),
                                  Text(station.name, style: TextStyle(fontSize: 20),)
                                ],
                              ),
                            ));
                        }
                      },
                    );
                  }
                },),
              ],
            )
          ),
          onLine: _buildOnlineWidget(station),
        )
      );
    });

    return timelineCards;
  }


  Widget _buildOnlineWidget(Station station) {
    if(station.isSelectedStation) {
      return TimelineIcon(
        Icons.directions_run,
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

    return Container(
      color: Colors.grey[200],
      child: ListView(
        primary: true,
        padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 50.0),
        children: _generateTimeline()
      ),
    );
  }
}


class IconRowButton extends StatelessWidget {

  final IconData icon;
  final String text;
  const IconRowButton({@required this.icon, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(text),
        ),
        Icon(icon),
      ],
    );
  }
}


///The bus cards
class BussCard extends StatefulWidget {
  final bool isWork;
  final Station stationAt;
  final Station selectedStation;
  BussCard(this.selectedStation, this.isWork, this.stationAt, {Key key}) : super(key: key);

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
                Row(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'At ',
                        style: Theme.of(context).textTheme.subhead,
                        children: <TextSpan>[
                          TextSpan(text: widget.isWork ? 'your work' : widget.selectedStation.name, style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ' in'),
                        ],
                      ),
                    )
                  ],
                ),
                TimeLeftCounter(
                  widget.selectedStation.timeWhenBussArive
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

  TimelineLine({Key key, @required this.child, @required this.onLine, @required this.isUpcomming, @required this.isCurrentEvent, @required this.isLastEvent, this.importantLevel = 0}) : super(key: key);

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
