
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


class TravelDummyCreator {

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