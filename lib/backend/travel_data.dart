import 'dart:convert';

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

  ///Getting the duration until the bus arriving at this station
  Duration durationUntilBuss() {
    return timeWhenBussArive.difference(DateTime.now());
  }

}


class StationData {

  ///Getting the next station that the bus is going to stop at
  static Station getNextStation(List<Station> stations) {
    for(var station in stations) {
      if(station.isUpcomming()) {
        return station;
      }
    }
    return null;
  }

  
  ///Get The station that is selected
  static Station getSelectedStation(List<Station> stations) {
    for(var station in stations) {
      if(station.isSelectedStation) {
        return station;
      }
    }
    return null;
  }


  ///Returning true if the bus is at the given station
  static bool isBusAtStation(Station station) {
    var timeDiff = station.timeWhenBussArive.difference(DateTime.now()).inSeconds.abs();
    return timeDiff < 5;
  }


  ///Getting the station that the bus is currently at, null if bus is not
  ///in any station
  static Station getStationBusIsAt(List<Station> stations) {
    for(var station in stations) {
      if(isBusAtStation(station)) {
        return station;
      }
    }
    return null;
  }
}


class TravelDummyCreator {

  static dynamic getRoutes() {
    return json.decode(routes);
  }

  static List<Station> createStations() {
    var stationTime = DateTime.now().subtract(Duration(minutes: 5));
    List<Station> stations = [];

    stations.add(Station(
      name: 'Gullmarsplan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.298404, 18.079349),
    ));

    stationTime = stationTime.add(Duration(seconds: 30));
    stations.add(Station(
      name: 'Skanstull',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.307890, 18.075727),
    ));

    stationTime = stationTime.add(Duration(seconds: 30));
    stations.add(Station(
      name: 'Eriksdal',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.306291, 18.068771),
    ));

    stationTime = stationTime.add(Duration(seconds: 30));
    stations.add(Station(
      name: 'Södra station',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.312852, 18.057792),
    ));

    stationTime = stationTime.add(Duration(seconds: 30));
    stations.add(Station(
      name: 'Wollmar Yxkullsgatan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.316226, 18.058193),
    ));

    stationTime = stationTime.add(Duration(seconds: 30));
    stations.add(Station(
      name: 'Rosenlundsgatan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.314335, 18.056886),
    ));

    stationTime = stationTime.add(Duration(seconds: 30));
    stations.add(Station(
      name: 'Zinkensdamm',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.317970, 18.050198),
    ));
    
    stationTime = stationTime.add(Duration(seconds: 30));
    stations.add(Station(
      name: 'Ansgariegatan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.316884, 18.046470),
    ));

    stationTime = stationTime.add(Duration(seconds: 30));
    stations.add(Station(
      name: 'Varvsgatan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.318106, 18.039904),
    ));

    stationTime = stationTime.add(Duration(seconds: 30));
    stations.add(Station(
      name: 'Hornstull',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.316658, 18.033236),
    ));

    stationTime = stationTime.add(Duration(seconds: 30));
    stations.add(Station(
      name: 'Högalidsgatan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.318111, 18.035498),
    ));

    stationTime = stationTime.add(Duration(seconds: 30));
    stations.add(Station(
      name: 'Västerbroplan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.328381, 18.022002),
    ));

    stationTime = stationTime.add(Duration(seconds: 30));
    stations.add(Station(
      name: 'Mariebergsgatan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.333423, 18.024457),
    ));

    stationTime = stationTime.add(Duration(seconds: 30));
    stations.add(Station(
      name: 'Fridhemsplan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.332148, 18.029269),
    ));
    
    stationTime = stationTime.add(Duration(seconds: 15));
    stations.add(Station(
      name: 'Fleminggatan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.333741, 18.038048),
    ));

    stationTime = stationTime.add(Duration(seconds: 15));
    stations.add(Station(
      name: 'S:t Eriksplan', 
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.339490, 18.037127),
    ));

    stationTime = stationTime.add(Duration(seconds: 15));
    stations.add(Station(
      name: 'Dalagatan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.341431, 18.044584),
    ));

    stationTime = stationTime.add(Duration(seconds: 30));
    stations.add(Station(
      name: 'Odenplan',
      timeWhenBussArive: stationTime,
      coordinates: LatLng(59.343077, 18.050349),
      isSelectedStation: true
    ));

    stationTime = stationTime.add(Duration(minutes: 2));
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

    stationTime = stationTime.add(Duration(minutes: 3));
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

const routes = """
  [
    {
        "from": "Gullmarsplan",
        "to": "Skanstull",
        "coords": [
            true,
            [
                [
                    18.079312,
                    59.298398
                ],
                [
                    18.079257,
                    59.298481
                ],
                [
                    18.079162,
                    59.298626
                ],
                [
                    18.079122,
                    59.298684
                ],
                [
                    18.07923,
                    59.298741
                ],
                [
                    18.079381,
                    59.298834
                ],
                [
                    18.079557,
                    59.29896
                ],
                [
                    18.079645,
                    59.299011
                ],
                [
                    18.079735,
                    59.299053
                ],
                [
                    18.079823,
                    59.299085
                ],
                [
                    18.080082,
                    59.29915
                ],
                [
                    18.080206,
                    59.299174
                ],
                [
                    18.080868,
                    59.29926
                ],
                [
                    18.081092,
                    59.299264
                ],
                [
                    18.081338,
                    59.299258
                ],
                [
                    18.08149,
                    59.299251
                ],
                [
                    18.081523,
                    59.299231
                ],
                [
                    18.081555,
                    59.299216
                ],
                [
                    18.081601,
                    59.299196
                ],
                [
                    18.081677,
                    59.299186
                ],
                [
                    18.081916,
                    59.2992
                ],
                [
                    18.081992,
                    59.29922
                ],
                [
                    18.082033,
                    59.299243
                ],
                [
                    18.082097,
                    59.299356
                ],
                [
                    18.08209,
                    59.299396
                ],
                [
                    18.082072,
                    59.299437
                ],
                [
                    18.082032,
                    59.299474
                ],
                [
                    18.081974,
                    59.299496
                ],
                [
                    18.081921,
                    59.299513
                ],
                [
                    18.081834,
                    59.2996
                ],
                [
                    18.081228,
                    59.30055
                ],
                [
                    18.08061,
                    59.301359
                ],
                [
                    18.080314,
                    59.301785
                ],
                [
                    18.077461,
                    59.3063
                ],
                [
                    18.077291,
                    59.306525
                ],
                [
                    18.077159,
                    59.306739
                ],
                [
                    18.076696,
                    59.30765
                ],
                [
                    18.076656,
                    59.307713
                ],
                [
                    18.076601,
                    59.307805
                ],
                [
                    18.076455,
                    59.30779
                ],
                [
                    18.076409,
                    59.307785
                ],
                [
                    18.076301,
                    59.307772
                ],
                [
                    18.075806,
                    59.307714
                ]
            ]
        ]
    },
    {
        "from": "Skanstull",
        "to": "Eriksdal",
        "coords": [
            true,
            [
                [
                    18.075806,
                    59.307714
                ],
                [
                    18.074535,
                    59.307565
                ],
                [
                    18.074227,
                    59.307543
                ],
                [
                    18.073845,
                    59.307524
                ],
                [
                    18.073379,
                    59.307506
                ],
                [
                    18.072159,
                    59.307477
                ],
                [
                    18.071683,
                    59.307482
                ],
                [
                    18.071462,
                    59.307486
                ],
                [
                    18.070585,
                    59.307536
                ],
                [
                    18.069886,
                    59.307593
                ],
                [
                    18.069673,
                    59.307617
                ],
                [
                    18.069477,
                    59.307569
                ],
                [
                    18.069416,
                    59.307441
                ],
                [
                    18.069314,
                    59.307224
                ],
                [
                    18.069255,
                    59.307099
                ],
                [
                    18.068868,
                    59.306284
                ],
                [
                    18.068771,
                    59.306292
                ]
            ]
        ]
    },
    {
        "from": "Eriksdal",
        "to": "Södra station",
        "coords": [
            true,
            [
                [
                    18.068771,
                    59.306292
                ],
                [
                    18.068868,
                    59.306284
                ],
                [
                    18.069255,
                    59.307099
                ],
                [
                    18.069314,
                    59.307224
                ],
                [
                    18.069416,
                    59.307441
                ],
                [
                    18.069477,
                    59.307569
                ],
                [
                    18.069673,
                    59.307617
                ],
                [
                    18.069407,
                    59.307646
                ],
                [
                    18.067284,
                    59.307993
                ],
                [
                    18.067096,
                    59.308023
                ],
                [
                    18.06689,
                    59.308061
                ],
                [
                    18.066295,
                    59.308178
                ],
                [
                    18.065705,
                    59.308311
                ],
                [
                    18.065193,
                    59.308442
                ],
                [
                    18.06429,
                    59.308722
                ],
                [
                    18.061851,
                    59.309471
                ],
                [
                    18.061671,
                    59.309526
                ],
                [
                    18.061387,
                    59.309621
                ],
                [
                    18.060587,
                    59.30987
                ],
                [
                    18.059833,
                    59.31011
                ],
                [
                    18.059664,
                    59.31017
                ],
                [
                    18.05897,
                    59.310428
                ],
                [
                    18.058771,
                    59.310502
                ],
                [
                    18.058538,
                    59.310587
                ],
                [
                    18.058362,
                    59.310648
                ],
                [
                    18.058412,
                    59.310683
                ],
                [
                    18.058548,
                    59.310784
                ],
                [
                    18.058576,
                    59.310853
                ],
                [
                    18.058556,
                    59.310924
                ],
                [
                    18.058315,
                    59.311421
                ],
                [
                    18.058286,
                    59.311483
                ],
                [
                    18.058258,
                    59.311541
                ],
                [
                    18.058223,
                    59.311614
                ],
                [
                    18.058165,
                    59.311734
                ],
                [
                    18.058122,
                    59.311821
                ],
                [
                    18.058088,
                    59.311891
                ],
                [
                    18.057962,
                    59.312152
                ],
                [
                    18.057956,
                    59.312164
                ],
                [
                    18.05789,
                    59.312297
                ],
                [
                    18.057884,
                    59.312309
                ],
                [
                    18.057763,
                    59.31256
                ],
                [
                    18.057739,
                    59.312611
                ],
                [
                    18.05773,
                    59.312628
                ],
                [
                    18.057632,
                    59.312832
                ]
            ]
        ]
    },
    {
        "from": "Södra station",
        "to": "Wollmar Yxkullsgatan",
        "coords": [
            true,
            [
                [
                    18.057632,
                    59.312832
                ],
                [
                    18.057543,
                    59.313018
                ],
                [
                    18.057447,
                    59.313216
                ],
                [
                    18.057241,
                    59.313645
                ],
                [
                    18.057189,
                    59.313751
                ],
                [
                    18.057147,
                    59.313839
                ],
                [
                    18.056978,
                    59.314188
                ],
                [
                    18.056897,
                    59.314356
                ],
                [
                    18.056876,
                    59.314399
                ],
                [
                    18.056816,
                    59.314524
                ],
                [
                    18.056958,
                    59.314542
                ],
                [
                    18.058187,
                    59.314705
                ],
                [
                    18.061581,
                    59.315155
                ],
                [
                    18.061255,
                    59.315839
                ],
                [
                    18.060907,
                    59.316547
                ],
                [
                    18.059089,
                    59.31632
                ],
                [
                    18.058765,
                    59.316277
                ],
                [
                    18.058204,
                    59.316204
                ]
            ]
        ]
    },
    {
        "from": "Wollmar Yxkullsgatan",
        "to": "Rosenlundsgatan",
        "coords": [
            true,
            [
                [
                    18.058204,
                    59.316204
                ],
                [
                    18.05811,
                    59.316192
                ],
                [
                    18.057488,
                    59.316115
                ],
                [
                    18.056131,
                    59.315943
                ],
                [
                    18.056468,
                    59.315246
                ],
                [
                    18.05678,
                    59.314599
                ],
                [
                    18.056816,
                    59.314524
                ],
                [
                    18.056876,
                    59.314399
                ],
                [
                    18.056897,
                    59.314356
                ],
                [
                    18.056906,
                    59.314337
                ]
            ]
        ]
    },
    {
        "from": "Rosenlundsgatan",
        "to": "Zinkensdamm",
        "coords": [
            true,
            [
                [
                    18.056906,
                    59.314337
                ],
                [
                    18.056897,
                    59.314356
                ],
                [
                    18.056876,
                    59.314399
                ],
                [
                    18.056816,
                    59.314524
                ],
                [
                    18.05678,
                    59.314599
                ],
                [
                    18.056468,
                    59.315246
                ],
                [
                    18.056131,
                    59.315943
                ],
                [
                    18.056074,
                    59.316059
                ],
                [
                    18.055825,
                    59.316578
                ],
                [
                    18.055504,
                    59.317243
                ],
                [
                    18.055207,
                    59.317843
                ],
                [
                    18.055168,
                    59.317926
                ],
                [
                    18.055136,
                    59.317992
                ],
                [
                    18.054903,
                    59.317964
                ],
                [
                    18.054201,
                    59.317875
                ],
                [
                    18.052447,
                    59.317644
                ],
                [
                    18.050897,
                    59.317447
                ],
                [
                    18.05079,
                    59.317434
                ],
                [
                    18.050639,
                    59.317413
                ],
                [
                    18.050583,
                    59.317519
                ],
                [
                    18.050325,
                    59.317996
                ],
                [
                    18.050205,
                    59.31797
                ],
                [
                    18.050198,
                    59.317969
                ]
            ]
        ]
    },
    {
        "from": "Zinkensdamm",
        "to": "Ansgariegatan",
        "coords": [
            true,
            [
                [
                    18.050198,
                    59.317969
                ],
                [
                    18.050205,
                    59.31797
                ],
                [
                    18.050408,
                    59.317541
                ],
                [
                    18.050429,
                    59.317498
                ],
                [
                    18.050475,
                    59.317393
                ],
                [
                    18.050198,
                    59.31736
                ],
                [
                    18.050149,
                    59.317354
                ],
                [
                    18.049607,
                    59.317286
                ],
                [
                    18.046544,
                    59.316905
                ],
                [
                    18.046465,
                    59.316895
                ]
            ]
        ]
    },
    {
        "from": "Ansgariegatan",
        "to": "Varvsgatan",
        "coords": [
            true,
            [
                [
                    18.046465,
                    59.316895
                ],
                [
                    18.04646,
                    59.316895
                ],
                [
                    18.045765,
                    59.316797
                ],
                [
                    18.043276,
                    59.316479
                ],
                [
                    18.043091,
                    59.316457
                ],
                [
                    18.042961,
                    59.316442
                ],
                [
                    18.04097,
                    59.316192
                ],
                [
                    18.040771,
                    59.316167
                ],
                [
                    18.040751,
                    59.316214
                ],
                [
                    18.040707,
                    59.316314
                ],
                [
                    18.040486,
                    59.316789
                ],
                [
                    18.040396,
                    59.316976
                ],
                [
                    18.040097,
                    59.317615
                ],
                [
                    18.040008,
                    59.317787
                ],
                [
                    18.039992,
                    59.317818
                ],
                [
                    18.039866,
                    59.318102
                ]
            ]
        ]
    },
    {
        "from": "Varvsgatan",
        "to": "Hornstull",
        "coords": [
            true,
            [
                [
                    18.039866,
                    59.318102
                ],
                [
                    18.039992,
                    59.317818
                ],
                [
                    18.040008,
                    59.317787
                ],
                [
                    18.040097,
                    59.317615
                ],
                [
                    18.040396,
                    59.316976
                ],
                [
                    18.040486,
                    59.316789
                ],
                [
                    18.040707,
                    59.316314
                ],
                [
                    18.040751,
                    59.316214
                ],
                [
                    18.040771,
                    59.316167
                ],
                [
                    18.040586,
                    59.316141
                ],
                [
                    18.03728,
                    59.315723
                ],
                [
                    18.037065,
                    59.315696
                ],
                [
                    18.036867,
                    59.315671
                ],
                [
                    18.034498,
                    59.315366
                ],
                [
                    18.034263,
                    59.315339
                ],
                [
                    18.03419,
                    59.315429
                ],
                [
                    18.033834,
                    59.315935
                ],
                [
                    18.033739,
                    59.316034
                ],
                [
                    18.033604,
                    59.3162
                ],
                [
                    18.033299,
                    59.316729
                ],
                [
                    18.033254,
                    59.316815
                ],
                [
                    18.033102,
                    59.316791
                ],
                [
                    18.033152,
                    59.316705
                ],
                [
                    18.033195,
                    59.31665
                ]
            ]
        ]
    },
    {
        "from": "Hornstull",
        "to": "Högalidsgatan",
        "coords": [
            true,
            [
                [
                    18.033195,
                    59.31665
                ],
                [
                    18.033285,
                    59.316534
                ],
                [
                    18.033578,
                    59.316011
                ],
                [
                    18.03364,
                    59.315928
                ],
                [
                    18.033782,
                    59.315703
                ],
                [
                    18.033912,
                    59.315473
                ],
                [
                    18.03395,
                    59.315397
                ],
                [
                    18.033983,
                    59.315314
                ],
                [
                    18.03402,
                    59.315236
                ],
                [
                    18.034323,
                    59.31525
                ],
                [
                    18.034263,
                    59.315339
                ],
                [
                    18.03419,
                    59.315429
                ],
                [
                    18.033834,
                    59.315935
                ],
                [
                    18.033739,
                    59.316034
                ],
                [
                    18.033604,
                    59.3162
                ],
                [
                    18.033299,
                    59.316729
                ],
                [
                    18.033254,
                    59.316815
                ],
                [
                    18.032656,
                    59.317838
                ],
                [
                    18.032602,
                    59.317931
                ],
                [
                    18.032742,
                    59.317964
                ],
                [
                    18.032922,
                    59.318002
                ],
                [
                    18.033931,
                    59.318033
                ],
                [
                    18.034146,
                    59.318054
                ],
                [
                    18.035418,
                    59.318103
                ],
                [
                    18.035487,
                    59.318106
                ],
                [
                    18.035499,
                    59.318106
                ]
            ]
        ]
    },
    {
        "from": "Högalidsgatan",
        "to": "Västerbroplan",
        "coords": [
            true,
            [
                [
                    18.035499,
                    59.318106
                ],
                [
                    18.035487,
                    59.318106
                ],
                [
                    18.035418,
                    59.318103
                ],
                [
                    18.034146,
                    59.318054
                ],
                [
                    18.034481,
                    59.317411
                ],
                [
                    18.034546,
                    59.317255
                ],
                [
                    18.035168,
                    59.316105
                ],
                [
                    18.03643,
                    59.316267
                ],
                [
                    18.03678,
                    59.316312
                ],
                [
                    18.037,
                    59.315832
                ],
                [
                    18.037037,
                    59.315757
                ],
                [
                    18.037065,
                    59.315696
                ],
                [
                    18.036867,
                    59.315671
                ],
                [
                    18.034498,
                    59.315366
                ],
                [
                    18.034263,
                    59.315339
                ],
                [
                    18.03419,
                    59.315429
                ],
                [
                    18.033834,
                    59.315935
                ],
                [
                    18.033739,
                    59.316034
                ],
                [
                    18.033604,
                    59.3162
                ],
                [
                    18.033299,
                    59.316729
                ],
                [
                    18.033254,
                    59.316815
                ],
                [
                    18.032656,
                    59.317838
                ],
                [
                    18.032602,
                    59.317931
                ],
                [
                    18.032152,
                    59.318767
                ],
                [
                    18.032062,
                    59.318968
                ],
                [
                    18.03199,
                    59.319156
                ],
                [
                    18.031536,
                    59.319988
                ],
                [
                    18.030804,
                    59.321303
                ],
                [
                    18.030582,
                    59.321631
                ],
                [
                    18.030207,
                    59.322043
                ],
                [
                    18.029933,
                    59.322299
                ],
                [
                    18.028136,
                    59.3238
                ],
                [
                    18.024526,
                    59.326745
                ],
                [
                    18.02421,
                    59.327012
                ],
                [
                    18.023869,
                    59.327272
                ],
                [
                    18.023164,
                    59.327654
                ],
                [
                    18.022734,
                    59.327897
                ],
                [
                    18.0224,
                    59.328116
                ],
                [
                    18.022217,
                    59.328237
                ],
                [
                    18.022056,
                    59.32834
                ],
                [
                    18.022013,
                    59.328384
                ]
            ]
        ]
    },
    {
        "from": "Västerbroplan",
        "to": "Mariebergsgatan",
        "coords": [
            true,
            [
                [
                    18.022013,
                    59.328384
                ],
                [
                    18.021985,
                    59.328411
                ],
                [
                    18.021903,
                    59.328551
                ],
                [
                    18.021881,
                    59.328673
                ],
                [
                    18.021888,
                    59.328779
                ],
                [
                    18.02198,
                    59.328974
                ],
                [
                    18.022654,
                    59.329883
                ],
                [
                    18.023342,
                    59.330778
                ],
                [
                    18.023991,
                    59.331673
                ],
                [
                    18.023985,
                    59.331749
                ],
                [
                    18.023942,
                    59.331941
                ],
                [
                    18.023892,
                    59.332034
                ],
                [
                    18.02385,
                    59.33212
                ],
                [
                    18.023819,
                    59.332219
                ],
                [
                    18.023795,
                    59.332303
                ],
                [
                    18.023935,
                    59.332534
                ],
                [
                    18.024115,
                    59.332845
                ],
                [
                    18.024301,
                    59.333151
                ],
                [
                    18.024417,
                    59.333341
                ],
                [
                    18.024466,
                    59.333422
                ]
            ]
        ]
    },
    {
        "from": "Mariebergsgatan",
        "to": "Fridhemsplan",
        "coords": [
            true,
            [
                [
                    18.024466,
                    59.333422
                ],
                [
                    18.024417,
                    59.333341
                ],
                [
                    18.024301,
                    59.333151
                ],
                [
                    18.024115,
                    59.332845
                ],
                [
                    18.023935,
                    59.332534
                ],
                [
                    18.023795,
                    59.332303
                ],
                [
                    18.023745,
                    59.332208
                ],
                [
                    18.023745,
                    59.332087
                ],
                [
                    18.023751,
                    59.332031
                ],
                [
                    18.02377,
                    59.33193
                ],
                [
                    18.023801,
                    59.33175
                ],
                [
                    18.023985,
                    59.331749
                ],
                [
                    18.024266,
                    59.331754
                ],
                [
                    18.027035,
                    59.331842
                ],
                [
                    18.02777,
                    59.331898
                ],
                [
                    18.028254,
                    59.331965
                ],
                [
                    18.028549,
                    59.331984
                ],
                [
                    18.028803,
                    59.331994
                ],
                [
                    18.028898,
                    59.331998
                ],
                [
                    18.030452,
                    59.332053
                ],
                [
                    18.030864,
                    59.332066
                ],
                [
                    18.030948,
                    59.332069
                ],
                [
                    18.031112,
                    59.332073
                ],
                [
                    18.031275,
                    59.332071
                ],
                [
                    18.031379,
                    59.332236
                ],
                [
                    18.031211,
                    59.332223
                ],
                [
                    18.030931,
                    59.332202
                ],
                [
                    18.02927,
                    59.332139
                ]
            ]
        ]
    },
    {
        "from": "Fridhemsplan",
        "to": "Fleminggatan",
        "coords": [
            true,
            [
                [
                    18.02927,
                    59.332139
                ],
                [
                    18.028885,
                    59.332124
                ],
                [
                    18.028804,
                    59.332121
                ],
                [
                    18.028539,
                    59.332109
                ],
                [
                    18.02867,
                    59.332236
                ],
                [
                    18.029317,
                    59.332934
                ],
                [
                    18.029718,
                    59.333366
                ],
                [
                    18.029849,
                    59.333543
                ],
                [
                    18.031605,
                    59.333309
                ],
                [
                    18.031757,
                    59.333288
                ],
                [
                    18.031892,
                    59.333269
                ],
                [
                    18.031954,
                    59.33338
                ],
                [
                    18.032513,
                    59.334346
                ],
                [
                    18.032571,
                    59.334438
                ],
                [
                    18.032791,
                    59.334409
                ],
                [
                    18.034217,
                    59.334222
                ],
                [
                    18.034426,
                    59.334196
                ],
                [
                    18.034649,
                    59.334167
                ],
                [
                    18.035394,
                    59.33407
                ],
                [
                    18.035598,
                    59.334043
                ],
                [
                    18.035804,
                    59.334016
                ],
                [
                    18.038025,
                    59.333727
                ],
                [
                    18.03804,
                    59.333725
                ]
            ]
        ]
    },
    {
        "from": "Fleminggatan",
        "to": "S:t Eriksplan",
        "coords": [
            true,
            [
                [
                    18.03804,
                    59.333725
                ],
                [
                    18.038266,
                    59.333695
                ],
                [
                    18.038294,
                    59.333749
                ],
                [
                    18.038052,
                    59.333781
                ],
                [
                    18.03583,
                    59.334072
                ],
                [
                    18.035624,
                    59.334098
                ],
                [
                    18.03542,
                    59.334126
                ],
                [
                    18.034678,
                    59.334223
                ],
                [
                    18.034453,
                    59.334252
                ],
                [
                    18.034246,
                    59.334279
                ],
                [
                    18.032822,
                    59.334466
                ],
                [
                    18.032612,
                    59.334494
                ],
                [
                    18.032694,
                    59.334597
                ],
                [
                    18.032954,
                    59.33491
                ],
                [
                    18.033429,
                    59.335466
                ],
                [
                    18.034133,
                    59.336331
                ],
                [
                    18.034479,
                    59.336734
                ],
                [
                    18.035442,
                    59.337981
                ],
                [
                    18.036512,
                    59.339312
                ],
                [
                    18.036635,
                    59.339475
                ],
                [
                    18.036646,
                    59.339488
                ],
                [
                    18.036693,
                    59.339554
                ],
                [
                    18.036774,
                    59.339665
                ],
                [
                    18.037469,
                    59.34083
                ],
                [
                    18.037518,
                    59.340906
                ],
                [
                    18.037629,
                    59.341076
                ],
                [
                    18.037721,
                    59.341205
                ],
                [
                    18.037754,
                    59.341166
                ],
                [
                    18.037824,
                    59.341084
                ],
                [
                    18.037981,
                    59.340901
                ],
                [
                    18.038723,
                    59.340033
                ],
                [
                    18.038767,
                    59.339981
                ],
                [
                    18.038833,
                    59.339904
                ],
                [
                    18.038647,
                    59.339826
                ],
                [
                    18.038575,
                    59.339808
                ],
                [
                    18.037414,
                    59.339517
                ],
                [
                    18.037353,
                    59.339501
                ],
                [
                    18.037335,
                    59.339475
                ]
            ]
        ]
    },
    {
        "from": "S:t Eriksplan",
        "to": "Dalagatan",
        "coords": [
            true,
            [
                [
                    18.037335,
                    59.339475
                ],
                [
                    18.037335,
                    59.339475
                ],
                [
                    18.03734,
                    59.33945
                ],
                [
                    18.037368,
                    59.339426
                ],
                [
                    18.037396,
                    59.339411
                ],
                [
                    18.037434,
                    59.339395
                ],
                [
                    18.037576,
                    59.339344
                ],
                [
                    18.039273,
                    59.339055
                ],
                [
                    18.039481,
                    59.339054
                ],
                [
                    18.03952,
                    59.339063
                ],
                [
                    18.039594,
                    59.339079
                ],
                [
                    18.039733,
                    59.33911
                ],
                [
                    18.039646,
                    59.339198
                ],
                [
                    18.039151,
                    59.339758
                ],
                [
                    18.039019,
                    59.33988
                ],
                [
                    18.039187,
                    59.339922
                ],
                [
                    18.040653,
                    59.3403
                ],
                [
                    18.040829,
                    59.340345
                ],
                [
                    18.042356,
                    59.34073
                ],
                [
                    18.042554,
                    59.340771
                ],
                [
                    18.043833,
                    59.341081
                ],
                [
                    18.044075,
                    59.34114
                ],
                [
                    18.045525,
                    59.341492
                ],
                [
                    18.04576,
                    59.341547
                ],
                [
                    18.04569,
                    59.341619
                ],
                [
                    18.045464,
                    59.34156
                ],
                [
                    18.044652,
                    59.341359
                ]
            ]
        ]
    },
    {
        "from": "Dalagatan",
        "to": "Odenplan",
        "coords": [
            true,
            [
                [
                    18.044652,
                    59.341359
                ],
                [
                    18.044011,
                    59.341201
                ],
                [
                    18.043781,
                    59.341143
                ],
                [
                    18.042504,
                    59.340823
                ],
                [
                    18.042312,
                    59.340776
                ],
                [
                    18.040777,
                    59.340401
                ],
                [
                    18.0406,
                    59.340355
                ],
                [
                    18.040653,
                    59.3403
                ],
                [
                    18.040829,
                    59.340345
                ],
                [
                    18.042356,
                    59.34073
                ],
                [
                    18.042554,
                    59.340771
                ],
                [
                    18.043833,
                    59.341081
                ],
                [
                    18.044075,
                    59.34114
                ],
                [
                    18.045525,
                    59.341492
                ],
                [
                    18.04576,
                    59.341547
                ],
                [
                    18.046009,
                    59.341607
                ],
                [
                    18.04725,
                    59.341928
                ],
                [
                    18.047402,
                    59.341979
                ],
                [
                    18.047558,
                    59.342024
                ],
                [
                    18.048616,
                    59.342286
                ],
                [
                    18.048838,
                    59.342341
                ],
                [
                    18.049049,
                    59.342394
                ],
                [
                    18.049909,
                    59.342602
                ],
                [
                    18.05085,
                    59.342832
                ],
                [
                    18.050932,
                    59.342851
                ],
                [
                    18.050986,
                    59.342865
                ],
                [
                    18.051069,
                    59.342884
                ],
                [
                    18.052275,
                    59.343147
                ],
                [
                    18.05223,
                    59.3432
                ],
                [
                    18.052195,
                    59.343241
                ],
                [
                    18.051952,
                    59.343196
                ],
                [
                    18.05095,
                    59.34314
                ],
                [
                    18.050343,
                    59.343115
                ]
            ]
        ]
    },
    {
        "from": "Odenplan",
        "to": "Stadsbiblioteket",
        "coords": [
            true,
            [
                [
                    18.050343,
                    59.343115
                ],
                [
                    18.048392,
                    59.343035
                ],
                [
                    18.048156,
                    59.343025
                ],
                [
                    18.047318,
                    59.342996
                ],
                [
                    18.047043,
                    59.342963
                ],
                [
                    18.046688,
                    59.342938
                ],
                [
                    18.04659,
                    59.342893
                ],
                [
                    18.046571,
                    59.342863
                ],
                [
                    18.046563,
                    59.342847
                ],
                [
                    18.046552,
                    59.342808
                ],
                [
                    18.046563,
                    59.342773
                ],
                [
                    18.046573,
                    59.342762
                ],
                [
                    18.047236,
                    59.342069
                ],
                [
                    18.047294,
                    59.342017
                ],
                [
                    18.047402,
                    59.341979
                ],
                [
                    18.047558,
                    59.342024
                ],
                [
                    18.048616,
                    59.342286
                ],
                [
                    18.048838,
                    59.342341
                ],
                [
                    18.049049,
                    59.342394
                ],
                [
                    18.049909,
                    59.342602
                ],
                [
                    18.05085,
                    59.342832
                ],
                [
                    18.050932,
                    59.342851
                ],
                [
                    18.050986,
                    59.342865
                ],
                [
                    18.051069,
                    59.342884
                ],
                [
                    18.052275,
                    59.343147
                ],
                [
                    18.053487,
                    59.34345
                ],
                [
                    18.053571,
                    59.343471
                ],
                [
                    18.054028,
                    59.343589
                ],
                [
                    18.05521,
                    59.34387
                ],
                [
                    18.055325,
                    59.343898
                ],
                [
                    18.055498,
                    59.343941
                ],
                [
                    18.055664,
                    59.343979
                ],
                [
                    18.055617,
                    59.344029
                ],
                [
                    18.055562,
                    59.344089
                ],
                [
                    18.055493,
                    59.34416
                ],
                [
                    18.055058,
                    59.344614
                ],
                [
                    18.054999,
                    59.344673
                ],
                [
                    18.054935,
                    59.344739
                ],
                [
                    18.054798,
                    59.344704
                ],
                [
                    18.054859,
                    59.344638
                ],
                [
                    18.055146,
                    59.344323
                ]
            ]
        ]
    },
    {
        "from": "Stadsbiblioteket",
        "to": "Roslagsgatan",
        "coords": [
            true,
            [
                [
                    18.055146,
                    59.344323
                ],
                [
                    18.055291,
                    59.344164
                ],
                [
                    18.05533,
                    59.344121
                ],
                [
                    18.055394,
                    59.344053
                ],
                [
                    18.055453,
                    59.343991
                ],
                [
                    18.055498,
                    59.343941
                ],
                [
                    18.055664,
                    59.343979
                ],
                [
                    18.05594,
                    59.344036
                ],
                [
                    18.056463,
                    59.344162
                ],
                [
                    18.056901,
                    59.344275
                ],
                [
                    18.057552,
                    59.344449
                ],
                [
                    18.057667,
                    59.344479
                ],
                [
                    18.057913,
                    59.344541
                ],
                [
                    18.058065,
                    59.344579
                ],
                [
                    18.059444,
                    59.344928
                ],
                [
                    18.059613,
                    59.344968
                ],
                [
                    18.059869,
                    59.345017
                ],
                [
                    18.06079,
                    59.345247
                ],
                [
                    18.060973,
                    59.345299
                ],
                [
                    18.060929,
                    59.345344
                ],
                [
                    18.060879,
                    59.345397
                ],
                [
                    18.060828,
                    59.34545
                ],
                [
                    18.060284,
                    59.346022
                ],
                [
                    18.060214,
                    59.346095
                ],
                [
                    18.060133,
                    59.346176
                ],
                [
                    18.059452,
                    59.346893
                ]
            ]
        ]
    },
    {
        "from": "Roslagsgatan",
        "to": "Valhallavägen",
        "coords": [
            true,
            [
                [
                    18.059452,
                    59.346893
                ],
                [
                    18.060133,
                    59.346176
                ],
                [
                    18.060214,
                    59.346095
                ],
                [
                    18.060284,
                    59.346022
                ],
                [
                    18.060828,
                    59.34545
                ],
                [
                    18.060879,
                    59.345397
                ],
                [
                    18.060929,
                    59.345344
                ],
                [
                    18.060973,
                    59.345299
                ],
                [
                    18.061232,
                    59.345368
                ],
                [
                    18.062436,
                    59.345672
                ],
                [
                    18.062514,
                    59.345691
                ],
                [
                    18.062647,
                    59.345723
                ],
                [
                    18.062709,
                    59.345738
                ],
                [
                    18.063183,
                    59.345876
                ],
                [
                    18.063305,
                    59.345937
                ],
                [
                    18.064206,
                    59.346155
                ],
                [
                    18.064367,
                    59.346194
                ],
                [
                    18.065049,
                    59.346359
                ],
                [
                    18.065223,
                    59.346401
                ],
                [
                    18.06545,
                    59.346456
                ],
                [
                    18.066194,
                    59.346636
                ],
                [
                    18.066383,
                    59.346655
                ],
                [
                    18.066629,
                    59.346709
                ],
                [
                    18.066679,
                    59.346737
                ],
                [
                    18.066755,
                    59.346788
                ],
                [
                    18.066801,
                    59.346819
                ]
            ]
        ]
    },
    {
        "from": "Valhallavägen",
        "to": "Östra station",
        "coords": [
            true,
            [
                [
                    18.066801,
                    59.346819
                ],
                [
                    18.066844,
                    59.346847
                ],
                [
                    18.067052,
                    59.346975
                ],
                [
                    18.067086,
                    59.347
                ],
                [
                    18.067101,
                    59.347011
                ],
                [
                    18.067047,
                    59.347023
                ],
                [
                    18.066938,
                    59.347024
                ],
                [
                    18.066849,
                    59.347012
                ],
                [
                    18.066728,
                    59.346938
                ],
                [
                    18.066687,
                    59.346912
                ],
                [
                    18.066584,
                    59.346844
                ],
                [
                    18.066755,
                    59.346788
                ],
                [
                    18.066875,
                    59.346742
                ],
                [
                    18.06709,
                    59.346663
                ],
                [
                    18.067579,
                    59.346483
                ],
                [
                    18.068086,
                    59.3463
                ],
                [
                    18.068416,
                    59.346185
                ],
                [
                    18.069245,
                    59.345896
                ],
                [
                    18.069549,
                    59.345788
                ],
                [
                    18.069717,
                    59.345739
                ],
                [
                    18.070745,
                    59.345484
                ]
            ]
        ]
    }
]
""";