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
      coordinates: LatLng(59.298404, 18.079349),
    ));

    stationTime = stationTime.add(Duration(minutes: 2));
    stations.add(Station(
      name: 'Skanstull',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.307890, 18.075727),
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Eriksdal',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.306291, 18.068771),
    ));

    stationTime = stationTime.add(Duration(minutes: 2));
    stations.add(Station(
      name: 'Södra station',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.312852, 18.057792),
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Wollmar Yxkullsgatan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.316226, 18.058193),
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Rosenlundsgatan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.314335, 18.056886),
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Zinkensdamm',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.317970, 18.050198),
    ));
    
    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Ansgariegatan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.316884, 18.046470),
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Varvsgatan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.318106, 18.039904),
    ));

    stationTime = stationTime.add(Duration(minutes: 2));
    stations.add(Station(
      name: 'Hornstull',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.316658, 18.033236),
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Högalidsgatan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.318111, 18.035498),
    ));

    stationTime = stationTime.add(Duration(minutes: 2));
    stations.add(Station(
      name: 'Västerbroplan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.328381, 18.022002),
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Mariebergsgatan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.333423, 18.024457),
    ));

    stationTime = stationTime.add(Duration(minutes: 2));
    stations.add(Station(
      name: 'Fridhemsplan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.332148, 18.029269),
    ));
    
    stationTime = stationTime.add(Duration(minutes: 2));
    stations.add(Station(
      name: 'Fleminggatan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.333741, 18.038048),
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'S:t Eriksplan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.339490, 18.037127),
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Dalagatan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.341431, 18.044584),
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Odenplan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.343077, 18.050349),
      isSelectedStation: true
    ));

    stationTime = stationTime.add(Duration(minutes: 1));
    stations.add(Station(
      name: 'Stadsbiblioteket',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.344314, 18.055106),
    ));

    stationTime = stationTime.add(Duration(minutes: 2));
    stations.add(Station(
      name: 'Roslagsgatan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.346922, 18.059569),
    ));

    stationTime = stationTime.add(Duration(minutes: 2));
    stations.add(Station(
      name: 'Valhallavägen',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.346825, 18.066786),
    ));

    stationTime = stationTime.add(Duration(minutes: 2));
    stations.add(Station(
      name: 'Östra station',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.345546, 18.070804),
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