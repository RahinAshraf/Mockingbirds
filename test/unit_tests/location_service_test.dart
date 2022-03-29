import 'package:flutter_test/flutter_test.dart';
import 'package:veloplan/providers/location_service.dart';

void main(){
  final LocationService locationService = LocationService();

  test('Calling method on London locations retrieves the correct coordinates', () async {
    expect(await locationService.getPlaceCoords('Buckingham Palace, London'), [51.500978, -0.142345]);
    expect(await locationService.getPlaceCoords('Big Ben, London'), [51.50068575, -0.124592]);
    expect(await locationService.getPlaceCoords('Bush house'), [51.512238, -0.117272]);
  });

  //the app is targeted at London tourist, so to input non-London locations should not return the coordinates of non-London locations
  test('Calling method on non-London locations does not retrieve the results for non-London locations', () async {
    expect(await locationService.getPlaceCoords('Madrid'), isNot(equals([41.1101274, -3.77000115]))); //[41.1101274, -3.77000115] coordinates of Madrid, Spain
    expect(await locationService.getPlaceCoords('Paris'), isNot(equals([[49.03119759, 2.31339950]])));
    expect(await locationService.getPlaceCoords('Cairo'), isNot(equals([30.8715287, 31.25797182747])));
  });

  test('Calling method on the empty string returns empty list of coordinates', () async {
    expect(await locationService.getPlaceCoords(''), []);
  });

}