import 'package:cycle_app/Model/NearbyUsers.dart';
import 'package:cycle_app/Model/longLat.dart';
import 'package:cycle_app/Service/userService.dart';
import 'package:cycle_app/main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../globals.dart';

  Future<http.Response> postUserLocation(int userId,LongLat currentLocation) async {
      UserService userService = getIt.get<UserService>();
    var url = base_url + '/locations';

    var body = {
      'long': currentLocation.long.toString(),
      'lat': currentLocation.lat.toString()
    };
    final response = await http.post(url, body: body,headers: {"Authorization":"Bearer "+userService.tokenValue});
    //print(response.body);
    return response;
  }

  Future<http.Response> getNearbyUsers(LongLat currentLocation) async {
    var url = base_url+'/locations/nearby';
      UserService userService = getIt.get<UserService>();
    var urlWithQuery =
        _makeQueryURL(url, {'long': currentLocation.long, 'lat': currentLocation.lat});
    final response = await http.get(urlWithQuery,headers: {"Authorization":"Bearer "+userService.tokenValue});
    return response;
  }

  String _makeQueryURL(String url, Map<String,dynamic> queryParams){
    String returnURL = url+"?";
    for(var paramKey in queryParams.keys){
        returnURL = '${returnURL + paramKey}=${queryParams[paramKey]}&';
    }
    returnURL=returnURL.substring(0,returnURL.length-1);
    return returnURL;
  }
