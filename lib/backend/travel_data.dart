import 'package:google_maps_flutter/google_maps_flutter.dart';

///Data about a travel
class Travel {
  final DateTime begin;
  final DateTime end;
  final DateTime workTime;

  double startLatitude;
  double startLongitude;
  double endLatiude;
  double endLongitude;

  Travel(this.begin, this.end, this.workTime);

  ///Gets the duration until the travel is begning
  Duration durationUntilTravelBegin() {
    return this.begin.difference(DateTime.now());
  }
}


class Station {
  final String name;
  final DateTime timeWhenBussArive;
  final LatLng coordinates;
  bool isSelectedStation;
  final bool isWork;

  Station({this.name, this.timeWhenBussArive, this.coordinates, this.isSelectedStation = false, this.isWork = false});

  ///If this station is an upcomming station or not
  bool isUpcomming() {
    return !timeWhenBussArive.isBefore(DateTime.now());
  }
}


class TravelDummyCreator {

  static List<Station> createStations() {
    var stationTime = DateTime.now().subtract(Duration(minutes: 20));
    List<Station> stations = [];

    stations.add(Station(
      name: 'Gullmarsplan',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));

    stationTime = stationTime.add(Duration(minutes: 2));
    stations.add(Station(
      name: 'Skanstull',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Eriksdal',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));

    stationTime = stationTime.add(Duration(minutes: 2));
    stations.add(Station(
      name: 'Södra station',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Wollmar Yxkullsgatan',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Rosenlundsgatan',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Zinkensdamm',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));
    
    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Ansgariegatan',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Varvsgatan',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));

    stationTime = stationTime.add(Duration(minutes: 2));
    stations.add(Station(
      name: 'Hornstull',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Högalidsgatan',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));

    stationTime = stationTime.add(Duration(minutes: 2));
    stations.add(Station(
      name: 'Västerbroplan',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Mariebergsgatan',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));

    stationTime = stationTime.add(Duration(minutes: 2));
    stations.add(Station(
      name: 'Fridhemsplan',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));
    
    stationTime = stationTime.add(Duration(minutes: 2));
    stations.add(Station(
      name: 'Fleminggatan',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'S:t Eriksplan',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Dalagatan',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Odenplan',
      timeWhenBussArive: stationTime,
      coordinates: null,
      isSelectedStation: true
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Stadsbiblioteket',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));

    stationTime = stationTime.add(Duration(minutes: 2));
    stations.add(Station(
      name: 'Roslagsgatan',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));

    stationTime = stationTime.add(Duration(minutes: 2));
    stations.add(Station(
      name: 'Valhallavägen',
      timeWhenBussArive: stationTime,
      coordinates: null,
    ));

    stationTime = stationTime.add(Duration(minutes: 2));
    stations.add(Station(
      name: 'Östra station',
      timeWhenBussArive: stationTime,
      coordinates: null,
      isWork: true
    ));

    return stations;
  }

  ///Gets a travel object dummy that set travel start and end date some time after
  ///current date
  static Travel getTravelDummy() {
    var currentDate = DateTime.now();
    var travelStartDate = currentDate.add(Duration(hours: 1, minutes: 22, seconds: 10));
    var travelEndDate = travelStartDate.add(Duration(hours: 1)); 
    return Travel(
      travelStartDate,
      travelEndDate,
      travelEndDate.add(Duration(minutes: 25))
    );
  }
}