import 'package:cycle_app/Home/pages/MapPage/map.dart';
import 'package:cycle_app/Home/pages/MapPage/usersList.dart';
import 'package:cycle_app/Service/locationService.dart';
import 'package:cycle_app/Service/mapService.dart';
import 'package:cycle_app/Service/userService.dart';
import 'package:cycle_app/main.dart';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  Function toggleCollapse;
  bool collapsedState;
  MapPage({this.toggleCollapse, this.collapsedState});
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final UserService userService = getIt.get<UserService>();

  final LocationService locationService = getIt.get<LocationService>();

  final MapService mapService = getIt.get<MapService>();
  bool expandMap = false;
  toggleExpandMap() {
    this.setState(() {
      expandMap = !expandMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      !expandMap
          ? Column(
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                  child: Container(
                    child: StreamBuilder(
                        stream: mapService.shouldGetNearbyUsers$,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          //once value arrived
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            bool shouldGetNearbyUsers = snapshot.data;
                            if (shouldGetNearbyUsers == true) {
                              //return list of nearby users
                              return SafeArea(child: NearByUsersList());
                            } else {
                              //return a button to get nearby user
                              return SafeArea(
                                child: Center(
                                  child: FlatButton(
                                    color: Colors.green[300],
                                    onPressed: () {
                                      mapService.setGetNearbyUsers(true);
                                    },
                                    child: Container(
                                        width: MediaQuery.of(context).size.height,
                                      child: Center(
                                          child: Text("Get nearby cyclists.",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Titil",
                                                  fontSize: 20))),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        }),
                  ),
                )),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: Container(
                      height: MediaQuery.of(context).size.height * .4,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            blurRadius: 8,
                            color: Colors.black45,
                            spreadRadius: 2),
                      ]),
                      child: MyMap(
                          toggleExpandMap: toggleExpandMap,
                          expandedState: expandMap)),
                ),
              ],
            )
          : Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    blurRadius: 8, color: Colors.black45, spreadRadius: 2),
              ]),
              child: MyMap(
                  toggleExpandMap: toggleExpandMap, expandedState: expandMap)),
      Positioned(
          top: 5,
          left: 10,
          child: widget.collapsedState == false
              ? IconButton(
                  icon: Icon(Icons.menu, color: Colors.red[100], size: 40),
                  onPressed: () {
                    widget.toggleCollapse();
                  })
              : SafeArea(
                  child: IconButton(
                      icon: Icon(Icons.menu, color: Colors.red[300], size: 40),
                      onPressed: () {
                        widget.toggleCollapse();
                      }),
                ))
    ]);
  }
}