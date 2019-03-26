
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
    return DateTime.now().difference(this.begin);
  }
}