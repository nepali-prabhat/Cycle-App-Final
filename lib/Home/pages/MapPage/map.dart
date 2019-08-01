import 'dart:convert';
import 'package:cycle_app/Model/NearbyUsers.dart';
import 'package:cycle_app/Model/longLat.dart';
import 'package:cycle_app/Service/locationService.dart';
import 'package:cycle_app/Service/mapService.dart';
import 'package:cycle_app/Service/userService.dart';
import 'package:cycle_app/globals.dart';
import 'package:cycle_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:cycle_app/configs.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';

class MyMap extends StatefulWidget {
  final Function toggleExpandMap;
  final bool expandedState;
  MyMap({Key key, this.toggleExpandMap, this.expandedState}) : super(key: key);

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final LocationService locationService = getIt.get<LocationService>();

  final MapService mapService = getIt.get<MapService>();
  double zoom = 15;
  zoomIn() {
    if (zoom < 20) {
      this.setState(() {
        zoom += 3;
      });
    }
  }

  zoomOut() {
    if (zoom > 10) {
      this.setState(() {
        zoom -= 3;
      });
    }
  }
  Future<Text> getLocationName(long, lat )async{
    var url = "https://api.mapbox.com/geocoding/v5/mapbox.places/$long,$lat.json?access_token=${Configs().mapToken}&poi";
    var response = await http.get(url);    
    var body = json.decode(response.body);
    print("boiii");
    var features = body["features"];
    print(features[0]["place_name"]);
    
    if(features.length!=0 && response.statusCode==200){
      var address = features[0]["place_name"];
      return Text(address);
    }else{
      return Text("Couldn't get their address");
    }
  }
  List<Marker> _makeMarkers() {
    List<Marker> markers = new List<Marker>();
    markers.add(Marker(
      width: 80.0,
      height: 80.0,
      point: new LatLng(locationService.currentLocation.lat,
          locationService.currentLocation.long),
      builder: (ctx) => Icon(Icons.location_on, color: Colors.blue),
    ));
    if (mapService.shouldGetNearbyUsers == true) {
      if (mapService.nearbyUsersHasValue) {
        List<NearbyUsers> nearby = mapService.nearbyUsers;
        for (NearbyUsers user in nearby) {
          markers.add(Marker(
              width: 120.0,
              height: 120.0,
              point: LatLng(user.lat, user.long),
              builder: (ctx) => GestureDetector(
                  onTap: () {
                    Toast.show("${user.user.username}", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    showModalBottomSheet(
                        context: context,
                        builder: (builder) {
                          return Container(
                              height: MediaQuery.of(context).size.height / 1.75,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: CircleAvatar(
                                        maxRadius: 20,
                                        backgroundColor:
                                            Color.fromARGB(255, 235, 250, 253),
                                        child: Text(
                                          user.user.username
                                              .substring(0, 1)
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontFamily: 'Ubuntu',
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                      ),
                                      title: Text('${user.user.username}',
                                          style: TextStyle(
                                              fontFamily: 'Ubuntu',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green)),
                                      subtitle: Text('${user.user.bio}'),
                                    ),
                                    Container(
                                        height: 60,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () async {
                                                Toast.show(
                                                    "opening phone", context,
                                                    duration:
                                                        Toast.LENGTH_SHORT,
                                                    gravity: Toast.BOTTOM);
                                                UserService userService =
                                                    getIt.get<UserService>();
                                                http.Response response =
                                                    await http.get(
                                                        '$base_url/users/getUser/${user.user.username}',
                                                        headers: {
                                                      "Authorization":
                                                          "Bearer " +
                                                              userService
                                                                  .tokenValue
                                                    });
                                                var res =
                                                    json.decode(response.body);
                                                var phone = res["phone_no"];
                                                UrlLauncher.launch(
                                                    "tel:+977 $phone");
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(Icons.phone, color: Colors.green),
                                                  Text("Call")
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Toast.show("Comming soon. Please be patient.", context);
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(Icons.directions, color: Colors.green[200]),
                                                  Text("Directions")
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                        FutureBuilder(
                                          future: getLocationName(user.long,user.lat),
                                          builder:(context,snapshot){
                                            if(snapshot.connectionState==ConnectionState.done){
                                              return ListTile(
                                                leading: Icon(Icons.location_on, color:Colors.green,size:40.0),
                                                title:snapshot.data
                                                );
                                            }else{
                                              return ListTile(
                                                leading: Icon(Icons.location_on, color:Colors.green,size: 20,),
                                                title:Text("loading...")
                                                );
                                            }
                                          }
                                        ),

                                  ],
                                ),
                              ));
                        });
                  },
                  child: Icon(Icons.location_on, color: Colors.red))));
        }
      }
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: mapService.shouldUpdate$,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data == true) {
              //return map
              return StreamBuilder(
                  stream: mapService.shouldUpdate$,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      bool shouldUpdate = snapshot.data;
                      if (shouldUpdate) {
                        //return map
                        return StreamBuilder(
                            stream: mapService.updater$,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return Stack(
                                  children: <Widget>[
                                    FlutterMap(
                                      options: MapOptions(
                                          center: LatLng(
                                              locationService
                                                  .currentLocation.lat,
                                              locationService
                                                  .currentLocation.long),
                                          zoom: zoom),
                                      layers: [
                                        new TileLayerOptions(
                                          urlTemplate:
                                              "https://api.tiles.mapbox.com/v4/"
                                              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                                          additionalOptions: {
                                            'accessToken':
                                                getIt.get<Configs>().mapToken,
                                            'id': 'mapbox.streets',
                                          },
                                        ),
                                        new MarkerLayerOptions(
                                            markers: _makeMarkers()),
                                      ],
                                    ),
                                    Positioned(
                                      bottom: 20,
                                      right: 20,
                                      child: OutlineButton(
                                          color: Colors.blueGrey[100],
                                          child: Icon(
                                              widget.expandedState
                                                  ? Icons.fullscreen_exit
                                                  : Icons.zoom_out_map,
                                              color: Colors.black,
                                              size: 30),
                                          onPressed: () {
                                            widget.toggleExpandMap();
                                          }),
                                    ),
                                    Positioned(
                                      bottom: 20,
                                      left: 20,
                                      child: OutlineButton(
                                          color: Colors.blueGrey[100],
                                          child: Icon(Icons.zoom_out,
                                              color: Colors.black, size: 40),
                                          onPressed: () {
                                            zoomOut();
                                          }),
                                    ),
                                    Positioned(
                                      bottom: 60,
                                      left: 20,
                                      child: OutlineButton(
                                          color: Colors.blueGrey[100],
                                          child: Icon(Icons.zoom_in,
                                              color: Colors.black, size: 40),
                                          onPressed: () {
                                            zoomIn();
                                          }),
                                    )
                                  ],
                                );
                              }
                            });
                      } else {
                        //return button to make should update true
                        return RaisedButton(
                            onPressed: () {
                              mapService.setShouldUpdate(true);
                            },
                            child: Text("load Map :)"));
                      }
                    }
                  });
            } else {
              return Center(
                  child: RaisedButton(
                      onPressed: () {
                        mapService.setShouldUpdate(true);
                      },
                      child: Text("load Map :)")));
            }
          }
        });
  }
}
