import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class SheetTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollableSheet(
        maxSheetHeight: 0.95,
        minSheetHeight: 0.3,
        sheetStops: [0.0, 0.5, 1.0],
        child: GoogleMap(
          gestureRecognizers: Set()
            ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
            ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer())),
          initialCameraPosition: CameraPosition(
            target: LatLng(10, 10)
          ),
        ),
        constrainSheetChild: true,
        sheetChild: Container(
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.only(top: 25.0),
            child: ListView.builder(
              padding: EdgeInsets.all(0.0),
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey[index % 2 == 0 ? 200 : 100],
                  padding: EdgeInsets.all(15.0),
                  child: Center(
                    child: Text('Index' + index.toString()),
                  ),
                );
              },
            )
          ),
        ),
      ),
    );
  }
}

///A list that has a scrollable sheet at the bottom
class ScrollableSheet extends StatefulWidget {

  final Widget child;
  final Widget sheetChild;

  ///The height of the grab container
  static final grapHeight = 30.0;

  ///The max percent of space the sheet can take up of the ListView´s height.
  final double maxSheetHeight;

  ///The min percent of space the sheet can take up of the ListView´s height.
  final double minSheetHeight;

  ///If the content of [sheetChild] should be constrained to the viewport of the device.
  ///Should be used if ListView is used in [sheetChild]
  final bool constrainSheetChild;

  ///The different stops that the sheet is going to snap to. List should contain doubles between
  ///0.0 and 1.0. 1.0 represent [maxSheetHeight] and 0.0 [minSheetHeight]
  final List<double> sheetStops;

  ///The stop the sheet should start with. Do not need to be within the [sheetStop] list
  final double initSheetStop;

  ScrollableSheet({@required this.child, @required this.sheetChild, this.maxSheetHeight = 1.0, this.minSheetHeight = 0.3, this.constrainSheetChild = false, this.sheetStops = const [], this.initSheetStop});

  @override
  _ScrollableSheetState createState() => _ScrollableSheetState();
}

class _ScrollableSheetState extends State<ScrollableSheet> {

  var _scrollController = ScrollController();
  bool _initScrollPosSet = false;
  int _currentSheetStopIndex = 0;

  List<double> _normalizedSheetStops = [];
  double _normalizedInitSheetStop;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        
      });
    });
    _createNormalizeStops();
  }


  ///Normalize the stops the the margin of [maxSheetHeight] and [minSheetHeight]
  void _createNormalizeStops() {

    //Make a copy of the stops
    _normalizedSheetStops = widget.sheetStops;

    //Creating the normal
    var normal = widget.maxSheetHeight - widget.minSheetHeight;
    _normalizedSheetStops = _normalizedSheetStops.map((stop) {
      return stop * normal;
    }).toList();

    if(widget.initSheetStop != null) {
      _normalizedInitSheetStop = widget.initSheetStop * normal;
    }
  }


  ///Sets the init scroll position
  void _setInitScrollPos(double viewportHeight) {
    _initScrollPosSet = true;
    WidgetsBinding.instance
      .addPostFrameCallback((_) {
        if(_normalizedSheetStops.length != 0) {
          var sheetStop = _normalizedInitSheetStop ??_normalizedSheetStops.first;
          _scrollController.jumpTo(viewportHeight * sheetStop);
          _normalizedSheetStops.sort();
        }
      });
    
  }


  ///Getting the size of constrained sheet
  double _getConstrainedSheetHeight(double viewportHeight) {

    if(widget.constrainSheetChild && _scrollController.hasClients) {
      var height = _scrollController.offset + viewportHeight * (widget.minSheetHeight);

      //The height can no be negative
      if(height < 0) {
        return 0;
      }

      return height;
    }

    return null;
  }


  ///Scrolling to the closets stop.
  void _scrollToClosestStop(double viewportHeight) {
    
    //Check if there exist any stop
    if(_normalizedSheetStops.length == 0) {
      return;
    }

    var currentScrollPos = _scrollController.offset;
    var tmpMinimum;
    var minStop;
    
    //Check if the user scroll past all stops
    if(currentScrollPos > _normalizedSheetStops.last * viewportHeight) {
      return;
    }

    //Finding the closest stop from the current scroll position
    for (var stop in _normalizedSheetStops) {
      var distanceToStop = (currentScrollPos - viewportHeight * stop).abs();

      //Handicap the current sheet top. User often want to scroll to other
      //stop, not the same
      if(_currentSheetStopIndex == _normalizedSheetStops.indexOf(stop)) {
        distanceToStop *= 5;
      }

      //Check if the current distance is the smallest
      if(tmpMinimum == null || distanceToStop < tmpMinimum) {
        tmpMinimum = distanceToStop;
        minStop = stop;
      }
    }

    //Scrolling to closest stop
    _scrollToStopIndex(viewportHeight, _normalizedSheetStops.indexOf(minStop));
  }


  ///Scrolling to a given stop index
  void _scrollToStopIndex(double viewportHeight, int stopIndex) {
    _currentSheetStopIndex = stopIndex;
    _scrollController.animateTo(viewportHeight * _normalizedSheetStops[stopIndex], curve: Curves.easeOutExpo, duration: Duration(milliseconds: 500)).then((_) {

    });
  }


  ///Scrolling to next index
  void _scrollToNextStopIndex(double viewportHeight) {
    var newStopIndex = _currentSheetStopIndex + 1;
    newStopIndex = (newStopIndex % _normalizedSheetStops.length).round();
    _scrollToStopIndex(viewportHeight, newStopIndex);
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {

        //Set the init pos
        if(!_initScrollPosSet) {
          _setInitScrollPos(constrains.maxHeight);
        }

        return Listener(
          onPointerUp: (_) {
            _scrollToClosestStop(constrains.maxHeight);
          },
          child: Container(
            color: Colors.white,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[

                //The main content
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SheetContentDelegate(
                    viewportHeight: constrains.maxHeight,
                    minHeight: 1 - widget.maxSheetHeight,
                    maxHeight: 1 - widget.minSheetHeight,
                    child: Stack(
                      children: <Widget>[
                        widget.child,
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: GestureDetector(
                            onTap: () {
                              _scrollToNextStopIndex(constrains.maxHeight);
                            },
                            child: ClipRect(
                              child: Container(
                                margin: EdgeInsets.only(top: 20.0),
                                decoration: BoxDecoration(
                                  boxShadow: [BoxShadow(
                                    blurRadius: 20.0,
                                    color: Colors.black.withOpacity(0.1)
                                  )],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))
                                ),
                                height: ScrollableSheet.grapHeight,

                                //Grab icon
                                child: Center(
                                  child: Container(
                                    width: 75.0,
                                    height: 7.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.all(Radius.circular(7.0))
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                ),

                //The sheet content
                SliverToBoxAdapter(
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: widget.constrainSheetChild ? constrains.maxHeight * widget.maxSheetHeight: null,
                    child: Container(
                      color: Colors.white,
                      height: _getConstrainedSheetHeight(constrains.maxHeight),
                      child: widget.sheetChild,
                    )
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class SheetContentDelegate extends SliverPersistentHeaderDelegate {

  ///The content of this sheet
  final Widget child;

  ///How height the sheet can go before its content is scrolling
  final double maxHeight;

  ///How much of the sheet you can see
  final double minHeight;

  ///How heigh the viewport is in pixels
  final double viewportHeight;

  SheetContentDelegate({@required this.child, @required this.viewportHeight, this.maxHeight = 1.0, this.minHeight = 0.3});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => viewportHeight * maxHeight;

  @override
  double get minExtent => viewportHeight * minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

}