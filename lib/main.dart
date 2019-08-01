import 'package:cycle_app/Home/Layout.dart';
import 'package:cycle_app/Home/pages/newLogin.dart';
import 'package:cycle_app/Service/groupService.dart';
import 'package:cycle_app/Service/locationService.dart';
import 'package:cycle_app/Service/mapService.dart';
import 'package:cycle_app/Service/userService.dart';
import 'package:cycle_app/configs.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = new GetIt();

void main() {
  getIt.registerSingleton(UserService());
  getIt.registerSingleton(LocationService());
  //git ignored:
  getIt.registerSingleton(Configs());
  getIt.registerSingleton(MapService());
  getIt.registerSingleton(GroupService());

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "The Cycle App", home: MyApp(),
    //todo: implement group nav properly here
  ));
}

class MyApp extends StatelessWidget {
  final UserService userService = getIt.get<UserService>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: userService.isLoggedIn$,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: Text('loading screen here.')));
          }
          if (snapshot.connectionState == ConnectionState.active) {
            bool loggedIn = snapshot.data;
            if (loggedIn) {
              return Layout();
            } else {
              return NewLogin();
            }
          }
        });
  }
}
