import 'package:cycle_app/Model/longLat.dart';
import 'package:cycle_app/Service/mapService.dart';
import 'package:cycle_app/Service/userService.dart';
import 'package:cycle_app/globals.dart';
import 'package:cycle_app/main.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LocationService {
  BehaviorSubject<bool> _shouldPost;
  bool get shouldPost => _shouldPost.value;
  Observable<bool> get shouldPost$ => _shouldPost.stream;

  BehaviorSubject<LongLat> _currentLocation;
  LongLat get currentLocation => _currentLocation.value;
  Observable<LongLat> get currentLocation$ => _currentLocation.stream;

  Location _location = new Location();

  LocationService() {
    _shouldPost = new BehaviorSubject.seeded(false);
    _currentLocation = new BehaviorSubject<LongLat>.seeded(
        LongLat(lat: 27.6220523, long: 85.537907));
    _location.onLocationChanged().listen((Map<String, double> value) {
      //for now will always get device location
      LongLat newLocation =
          LongLat(long: value['longitude'], lat: value['latitude']);
      _currentLocation.add(newLocation);
      if (shouldPost) {
        http.post("$base_url/locations", headers: {
          "Authorization": "Bearer ${getIt.get<UserService>().tokenValue}"
        }, body: {
          "long": '${currentLocation.long}',
          "lat": '${currentLocation.lat}',
        }).then((response) {
          //print("current location end point : ${response.body}");
        });
      }
    });
    _readSettingsFromLocalStore();
  }

  void setShouldPost(bool value) {
    _shouldPost.add(value);
    _saveSettingsToLocalStore();
    //todo: post current location in database
  }

  void _saveSettingsToLocalStore() {
    SharedPreferences.getInstance().then((pref) {
      pref.setBool("shouldPost", shouldPost);
    });
  }

  void _readSettingsFromLocalStore() {
    SharedPreferences.getInstance().then((pref) {
      if (pref.containsKey('shouldPost')) {
        _shouldPost.add(pref.getBool("shouldPost"));
      }
    });
  }

  void _deleteSettingsFromLocalStore() {
    SharedPreferences.getInstance().then((pref) {
      pref.remove('shouldPost');
    });
  }

  void dispose() {
    _currentLocation.close();
    _shouldPost.close();
  }
}
