import 'package:cycle_app/Model/myEventsModel.dart';
import 'package:cycle_app/Service/eventService.dart';
import 'package:cycle_app/Service/userService.dart';
import 'package:cycle_app/main.dart';
import 'package:flutter/material.dart';
import 'package:cycle_app/Home/pages/EventsPage/myEvents.dart';

class EventsFeed extends StatelessWidget {
  final UserService userService = getIt.get<UserService>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          FutureBuilder(
            future: getAllEvents(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  return Center(child: Text("Server down. Please Wait..."));
                }
                if (snapshot.data.statusCode == 200) {
                  String body = snapshot.data.body;
                  List<MyEventsModel> myEvents = myEventsFromJson(body);
                  var evetsLayoutList = myEvents
                      .map((event) => (event.host != userService.userValue.id
                          ? MyEventLayout(event, isMine: false)
                          : SizedBox()))
                      .toList();
                  if (evetsLayoutList.length == 0) {
                    return Container(
                        height: 300,
                        child: Center(
                            child: Text('no events :( why dont you add one')));
                  }
                  return Column(
                    children: evetsLayoutList,
                  );
                } else {
                  return Center(
                      child: Text(
                          'server down. Be patient until we fix it back.'));
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }
}
