import 'package:cycle_app/Model/NearbyUsers.dart';
import 'package:cycle_app/Service/mapService.dart';
import 'package:cycle_app/configs.dart';
import 'package:cycle_app/main.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:http/http.dart' as http;
import 'package:cycle_app/Service/userService.dart';
import '../../../globals.dart';
import 'dart:convert';
import 'dart:async';

class NearByUsersList extends StatelessWidget {
  final MapService mapService = getIt.get<MapService>();
//  int getIndex(NearbyUsers user, List<NearbyUsers> nearby){
//      nearby.map((value)=>{
//         if(nearby.){

//         }
//      });
//  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: mapService.nearbyUsers$,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (mapService.nearbyUsersHasValue) {
              //return list of nearby users
              List<NearbyUsers> nearby = mapService.nearbyUsers;
              if (nearby.length == 0) {
                return Center(
                    child: Notify(
                  title: "No Cyclists near you.",
                  typeColor: NotifyType.error,
                  desc: "sorry fam.",
                ));
              }
              return ListView(
                  children: nearby.map((value) {
                return NearbyUsersListTile(
                    value,
                    nearby.lastIndexWhere(
                        (near) => near.user.username == value.user.username));
              }).toList());
            } else {
              //meaning it has errors, return an error message
              return Center(child: Text("Sorry, couldnt get nearby users."));
            }
          }
        });
  }
}

class NotifyType {
  static const Color error = Color.fromARGB(255, 247, 174, 158);
  static const Color normal = Color.fromARGB(255, 235, 250, 253);
  static const Color notify = Color.fromARGB(255, 196, 249, 184);
}

class Notify extends StatelessWidget {
  final String title;
  final String desc;
  final Color typeColor;

  const Notify(
      {Key key,
      this.title = "",
      this.desc = "",
      this.typeColor = NotifyType.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: typeColor),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("$title",
                  style: TextStyle(fontFamily: 'Titil', fontSize: 16)),
              Text("$desc",
                  style: TextStyle(
                      fontFamily: 'Catamaran',
                      color: Color.fromARGB(100, 0, 0, 0))),
            ],
          ),
        ));
  }
}

class NearbyUsersListTile extends StatelessWidget {
  final NearbyUsers nearby;
  final int number;
  NearbyUsersListTile(this.nearby, this.number);
  @override
  Widget build(BuildContext context) {
    String bio = nearby.user.bio;
    if (bio.length >= 20) {
      String smallBio = bio.substring(0, 20);
      int i = smallBio.lastIndexOf(" ");
      smallBio = smallBio.substring(0, i);
      smallBio = smallBio + " ...";
      bio = smallBio;
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
    Future<String> getPhoneNumber() async {
      UserService userService = getIt.get<UserService>();
      http.Response response = await http.get(
          '$base_url/users/getUser/${nearby.user.username}',
          headers: {"Authorization": "Bearer " + userService.tokenValue});
      var res = json.decode(response.body);
      return res["phone_no"];
    }

    String leadingNum = "${number + 1 < 10 ? "0" : ""}${number + 1}";
    return GestureDetector(
      onTap: () {
        Toast.show("${nearby.user.username}", context,
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
                            backgroundColor: Color.fromARGB(255, 235, 250, 253),
                            child: Text(
                              nearby.user.username.substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                          title: Text('${nearby.user.username}',
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                          subtitle: Text('${nearby.user.bio}'),
                        ),
                        Container(
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    Toast.show("opening phone", context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM);
                                    UserService userService =
                                        getIt.get<UserService>();
                                    http.Response response = await http.get(
                                        '$base_url/users/getUser/${nearby.user.username}',
                                        headers: {
                                          "Authorization":
                                              "Bearer " + userService.tokenValue
                                        });
                                    var res = json.decode(response.body);
                                    var phone = res["phone_no"];
                                    UrlLauncher.launch("tel:+977 $phone");
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.phone, color: Colors.green),
                                      Text("Call")
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Toast.show(
                                        "Comming soon. Please be patient.",
                                        context);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.directions,
                                          color: Colors.green[200]),
                                      Text("Directions")
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        FutureBuilder(
                            future: getLocationName(nearby.long, nearby.lat),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return ListTile(
                                    leading: Icon(Icons.location_on,
                                        color: Colors.green, size: 40.0),
                                    title: snapshot.data);
                              } else {
                                return ListTile(
                                    leading: Icon(
                                      Icons.location_on,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    title: Text("loading..."));
                              }
                            }),
                      ],
                    ),
                  ));
            });
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          children: <Widget>[
            Container(
              width: 50,
              child: Center(
                  child: Text(leadingNum,
                      style: TextStyle(fontFamily: 'Titil', fontSize: 25))),
            ),
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Row(
                      children: <Widget>[
                        //avatar
                        Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 235, 250, 253),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                                child: Text(
                                    "${nearby.user.username[0].toUpperCase()}",
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontSize: 30,
                                        color: Color(0xff2d386b))))),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("${nearby.user.username}",
                                  style: TextStyle(
                                      fontFamily: 'Titil', fontSize: 16)),
                              Text("$bio",
                                  style: TextStyle(
                                      fontFamily: 'Catamaran',
                                      color: Color.fromARGB(100, 0, 0, 0))),
                            ],
                          ),
                        )
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
