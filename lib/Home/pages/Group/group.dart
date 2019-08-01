import 'dart:async';

import 'package:cycle_app/Model/ParticipantsModel.dart';
import 'package:cycle_app/Model/groupModel.dart';
import 'package:cycle_app/Model/messageModel.dart';
import 'package:cycle_app/Model/myEventsModel.dart';
import 'package:cycle_app/StaticWidgets/sectionRuler.dart';
import 'package:cycle_app/globals.dart';
import 'package:cycle_app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cycle_app/Service/userService.dart';
import 'package:cycle_app/Service/groupService.dart';
import 'package:toast/toast.dart';

class Group extends StatefulWidget {
  final MyEventsModel event;
  final GroupModel group;
  Group({this.event, this.group});

  @override
  _GroupState createState() => _GroupState();
}

class _GroupState extends State<Group> {
  UserService userService = getIt.get<UserService>();
  GroupService groupService = getIt.get<GroupService>();
  TextEditingController message = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool renderLol = false;
  @override
  void initState() {
    groupService.setWillUpdate(true);
    super.initState();
  }

  void dispose() {
    groupService.resetMessage();
    groupService.setWillUpdate(false);
  }

  void postMessage() async {
    String msg = message.value.text.trim();
    if (msg.length != 0) {
      if (!postEditedText) {
        //send post request
        http.Response response = await http.post('$base_url/messages', body: {
          'text': msg,
          'user_id': "${userService.userValue.id}",
          'group_id': "${widget.group.id}"
        }, headers: {
          "Authorization": "Bearer ${getIt.get<UserService>().tokenValue}"
        });
        message.clear();
        this.setState(() {
          renderLol = true;
        });
      } else {
        //update the message
        http.Response response =
            await http.put('$base_url/messages/$editedId', body: {
          'text': msg + '-edited',
        }, headers: {
          "Authorization": "Bearer ${getIt.get<UserService>().tokenValue}"
        });
        message.clear();
        this.setState(() {
          postEditedText = false;
          editedId = -1;
        });
      }
    }
  }

  bool seeGroupDetails = false;
  bool postEditedText = false;
  int editedId = -1;
  Future<http.Response> getParticipants() {
    return http.get('$base_url/events/participants/${widget.event.id}',
        headers: {
          "Authorization": "Bearer ${getIt.get<UserService>().tokenValue}"
        });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.event);
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.group.name}'),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  seeGroupDetails = !seeGroupDetails;
                });
              },
              child: Padding(
                  padding: EdgeInsets.only(right: 15),
                  child:
                      Icon(!seeGroupDetails ? Icons.more_vert : Icons.close)),
            )
          ],
        ),
        body: !seeGroupDetails
            ? Container(
                child: Column(
                  children: <Widget>[
                    //messages
                    Expanded(
                      child: Container(
                          child: StreamBuilder(
                              stream: groupService.message$,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.active) {
                                  print('hello frand');
                                  print(groupService.willUpdate);
                                  List<MessageModel> msg = snapshot.data;
                                  return SingleChildScrollView(
                                    child: Container(
                                      child: Column(
                                          children: msg
                                              .map((m) => (GestureDetector(
                                                  onLongPressEnd:
                                                      (LongPressEndDetails
                                                          details) {
                                                    //open edit, delete option
                                                    if (m.userId ==
                                                        userService
                                                            .userValue.id) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  "Update msg",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18)),
                                                              actions: <Widget>[
                                                                OutlineButton(
                                                                  child: new Text(
                                                                      "Edit",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              Colors.green[300])),
                                                                  onPressed:
                                                                      () {
                                                                    // edit here
                                                                    message.text =
                                                                        '${m.text}';
                                                                    this.setState(
                                                                        () {
                                                                      postEditedText =
                                                                          true;
                                                                      editedId =
                                                                          m.id;
                                                                    });
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                                OutlineButton(
                                                                  child: new Text(
                                                                      "Delete",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              Colors.red[300])),
                                                                  onPressed:
                                                                      () async {
                                                                    //send delete request to server
                                                                    http.Response
                                                                        response =
                                                                        await http.delete(
                                                                            '$base_url/messages/${m.id}',
                                                                            headers: {
                                                                          "Authorization":
                                                                              "Bearer ${getIt.get<UserService>().tokenValue}"
                                                                        });
                                                                    if (response
                                                                            .statusCode ==
                                                                        200) {
                                                                      Toast.show(
                                                                          "deleted successfully.",
                                                                          context,
                                                                          duration: Toast
                                                                              .LENGTH_SHORT,
                                                                          gravity:
                                                                              Toast.BOTTOM);

                                                                      this.setState(
                                                                          () {
                                                                        return renderLol =
                                                                            true;
                                                                      });
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    } else {
                                                                      Toast.show(
                                                                          "couldn't delete.",
                                                                          context,
                                                                          duration: Toast
                                                                              .LENGTH_LONG,
                                                                          gravity:
                                                                              Toast.BOTTOM);
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    }
                                                  },
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 6),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: userService
                                                                      .userValue
                                                                      .id ==
                                                                  m.userId
                                                              ? Colors.blue[100]
                                                              : Colors
                                                                  .transparent),
                                                      child: ListTile(
                                                        title: Text(
                                                            '${m.user.fName} ${m.user.lName} (${m.updatedAt.hour}:${m.updatedAt.minute})'),
                                                        subtitle:
                                                            Text('${m.text}'),
                                                        leading: CircleAvatar(
                                                          maxRadius: 20,
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  235,
                                                                  250,
                                                                  253),
                                                          child: Text(
                                                            m.user.fName
                                                                .substring(0, 1)
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Ubuntu',
                                                                fontSize: 25,
                                                                color: Color(
                                                                    0xff2d386b)),
                                                          ),
                                                        ),
                                                      )))))
                                              .toList()),
                                    ),
                                  );
                                } else {
                                  print('lolll');
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              })),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Material(
                            elevation: 1,
                            child: Form(
                              key: _formKey,
                              child: Container(
                                  child: TextFormField(
                                      controller: message,
                                      decoration: new InputDecoration(
                                        hintText: "say something...",
                                        contentPadding: EdgeInsets.all(10.0),
                                      ))),
                            ),
                          ),
                        ),
                        OutlineButton(
                            child: Icon(Icons.send, color: Colors.blue[300]),
                            onPressed: () {
                              postMessage();
                            }),
                      ],
                    ),
                  ],
                ),
              )
            : Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      SectionRuler(
                        section: 'Participants:',
                        color: Colors.black,
                      ),
                      SizedBox(height: 10),
                      FutureBuilder(
                          future: getParticipants(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              http.Response response = snapshot.data;
                              if (response.statusCode == 200) {
                                List<ParticipantsModel> participants =
                                    participantsModelFromJson(response.body);
                                if (participants.length == 0) {
                                  return Center(
                                      child: Text("no participants."));
                                } else {
                                  return Center(
                                    child: Column(
                                        children: participants
                                            .map((p) =>
                                                (Text("${p.fName} ${p.lName}")))
                                            .toList()),
                                  );
                                }
                              } else {
                                return Center(
                                    child: Text("Couldn't get participants."));
                              }
                            }
                            return Center(child: CircularProgressIndicator());
                          })
                    ],
                  ),
                ),
              ));
  }
}
