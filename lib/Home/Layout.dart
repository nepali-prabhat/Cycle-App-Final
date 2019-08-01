import 'package:cycle_app/Home/pages/EventsPage/eventPage.dart';
import 'package:cycle_app/Home/pages/MapPage/mapPage.dart';
import 'package:cycle_app/Model/NearbyUsers.dart';
import 'package:cycle_app/Model/UserModel.dart';
import 'package:cycle_app/Model/longLat.dart';
import 'package:cycle_app/Service/locationService.dart';
import 'package:cycle_app/Service/mapService.dart';
import 'package:cycle_app/Service/userService.dart';
import 'package:cycle_app/StaticWidgets/sectionRuler.dart';
import 'package:cycle_app/configs.dart';
import 'package:cycle_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart';
import 'package:latlong/latlong.dart';

final backColor = Color.fromARGB(255, 117, 152, 247);
bool _isCollapsed = true;
double screenwidth, screenheight;

class Layout extends StatefulWidget {
  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> with SingleTickerProviderStateMixin {
  final Duration duration = Duration(milliseconds: 100);
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  UserService userService = getIt.get<UserService>();
  LocationService locationService = getIt.get<LocationService>();
  MapService mapService = getIt.get<MapService>();
  int activeIndex = 0;
  bool showSettings;
  changeActiveIndex(int i) {
    setState(() {
      activeIndex = i;
    });
  }

  @override
  void initState() {
    super.initState();
    showSettings = false;
    _controller = AnimationController(vsync: this, duration: duration);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.reverse();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          menu(context),
          home(context),
          showSettings ? Settings(closeController: closeSettings) : Container()
        ],
      ),
    );
  }

  toggleCollapse() {
    setState(() {
      if (_isCollapsed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      _isCollapsed = !_isCollapsed;
    });
  }

  closeSettings() {
    setState(() {
      showSettings = false;
    });
  }

  Widget menu(context) {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  maxRadius: 40,
                  backgroundColor: Color.fromARGB(255, 235, 250, 253),
                  child: Text(
                    userService.userValue.username
                        .substring(0, 1)
                        .toUpperCase(),
                    style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 35,
                        color: Color(0xff2d386b)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  userService.userValue.username.toLowerCase(),
                  style: TextStyle(
                      color: Colors.black, fontSize: 30, fontFamily: 'Titil'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    userService.userValue.bio,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontFamily: 'Catamaran'),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: FlatButton(
                    onPressed: () {
                      changeActiveIndex(0);
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.directions_bike, color: Colors.blue),
                            SizedBox(width: 10),
                            Text("Cyclists",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Titil",
                                    fontSize: 20))
                          ],
                        )),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: FlatButton(
                    onPressed: () {
                      changeActiveIndex(1);
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.event_note,
                                color: Colors.indigo[300], size: 25),
                            SizedBox(width: 10),
                            Text("Events",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Titil",
                                    fontSize: 21))
                          ],
                        )),
                  ),
                ),
                SizedBox(height: 30),
                //settings button
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        if (showSettings == false) {
                          showSettings = true;
                        }
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.settings, color: Colors.deepPurple[300]),
                            SizedBox(width: 10),
                            Text("Settings",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Titil",
                                    fontSize: 20))
                          ],
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(),
        )
      ],
    );
  }

  Widget getPagesBasedOnIndex() {
    if (activeIndex == 0) {
      return MapPage(
          toggleCollapse: toggleCollapse, collapsedState: _isCollapsed);
    } else {
      return EventPage(
          toggleCollapse: toggleCollapse, collapsedState: _isCollapsed);
    }
  }

  Widget home(context) {
    Size size = MediaQuery.of(context).size;
    screenheight = size.height;
    screenwidth = size.width;

    return AnimatedPositioned(
        duration: duration,
        top: _isCollapsed ? 0 : 0.2 * screenheight,
        bottom: _isCollapsed ? 0 : 0.2 * screenwidth,
        left: _isCollapsed ? 0 : 0.6 * screenwidth,
        right: _isCollapsed ? 0 : -0.4 * screenwidth,
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(60)),
          elevation: 20.0,
          color: backColor,
          child: Scaffold(
            body: Container(child: getPagesBasedOnIndex()),
          ),
        ));
  }
}

class Settings extends StatefulWidget {
  final Function closeController;

  Settings({Key key, this.closeController}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final UserService userService = getIt.get<UserService>();

  final LocationService locationService = getIt.get<LocationService>();

  final MapService mapService = getIt.get<MapService>();
  bool changeProfile = false;
  toggleChangeProgile() {
    setState(() {
      changeProfile = !changeProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool permission = userService.userValue.permission == 1 ? true : false;
    bool post = locationService.shouldPost;
    return SingleChildScrollView(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            !changeProfile
                ? Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15,
                              spreadRadius: 100)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //top section(box title and close button)
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(Icons.settings,
                                          color: Colors.deepPurple[300]),
                                      SizedBox(width: 10),
                                      Text("Settings",
                                          style: TextStyle(
                                              color: Colors.deepPurple[300],
                                              fontFamily: "Titil",
                                              fontSize: 20))
                                    ],
                                  )),
                            ),
                            Container(
                                width: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5)),
                                child: FlatButton(
                                    onPressed: () {
                                      widget.closeController();
                                    },
                                    child: Icon(Icons.close,
                                        color: Colors.red[300]))),
                          ],
                        ),

                        SizedBox(height: 30),
                        SectionRuler(
                            section: "Change permissions.",
                            color: Colors.black45),
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Public Location",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Titil",
                                      color: Color.fromARGB(130, 0, 0, 0))),
                              Switch(
                                  value: post,
                                  onChanged: (value) {
                                    //change in database
                                    locationService.setShouldPost(value);
                                  })
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Get Nearby Cyclists",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Titil",
                                      color: Color.fromARGB(130, 0, 0, 0))),
                              Switch(
                                  value: mapService.shouldGetNearbyUsers,
                                  onChanged: (value) {
                                    //change in database
                                    mapService.setGetNearbyUsers(value);
                                  })
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Public Info",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Titil",
                                      color: Color.fromARGB(130, 0, 0, 0))),
                              Switch(
                                  value: permission,
                                  onChanged: (value) {
                                    //change in database
                                    userService.changePermission(value);
                                  })
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: FlatButton(
                              color: Colors.red[300],
                              onPressed: () {
                                userService.logOut();
                              },
                              child: Center(
                                  child: Text("Log Out",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Titil",
                                          fontSize: 20))),
                            )),
                        SizedBox(height: 30),
                        SectionRuler(
                            section: "Your Profile.", color: Colors.black45),
                        SizedBox(height: 30),
                        //profile start
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text("Username:",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Titil",
                                  color: Color.fromARGB(130, 0, 0, 0))),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Text(userService.userValue.username,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Titil",
                                  color: Color.fromARGB(100, 0, 0, 0))),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text("Bio:",
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Titil",
                                  color: Color.fromARGB(130, 0, 0, 0))),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Text(userService.userValue.bio,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Titil",
                                  color: Color.fromARGB(100, 0, 0, 0))),
                        ),

                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text("First Name:",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Titil",
                                  color: Color.fromARGB(130, 0, 0, 0))),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Text(userService.userValue.fName,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Titil",
                                  color: Color.fromARGB(100, 0, 0, 0))),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text("Last Name:",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Titil",
                                  color: Color.fromARGB(130, 0, 0, 0))),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Text(userService.userValue.lName,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Titil",
                                  color: Color.fromARGB(100, 0, 0, 0))),
                        ),

                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text("Email:",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Titil",
                                  color: Color.fromARGB(130, 0, 0, 0))),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Text(userService.userValue.email,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Titil",
                                  color: Color.fromARGB(100, 0, 0, 0))),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text("Phone:",
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Titil",
                                  color: Color.fromARGB(130, 0, 0, 0))),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Text(userService.userValue.phoneNo,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Titil",
                                  color: Color.fromARGB(100, 0, 0, 0))),
                        ),

                        SizedBox(height: 30),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: FlatButton(
                              color: Colors.green[300],
                              onPressed: () {
                                toggleChangeProgile();
                              },
                              child: Center(
                                  child: Text("Change Profile",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Titil",
                                          fontSize: 20))),
                            )),
                        SizedBox(height: 30),
                      ],
                    ))
                : ChangeProfile(
                    toggleChangeProfile: toggleChangeProgile,
                    user: userService.userValue)
          ],
        ),
      ),
    );
  }
}

class ChangeProfile extends StatefulWidget {
  final Function toggleChangeProfile;
  final UserModel user;
  ChangeProfile({Key key, this.toggleChangeProfile, this.user})
      : super(key: key);

  @override
  _ChangeProfileState createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  TextEditingController username;
  TextEditingController bio;
  TextEditingController fName;
  TextEditingController lName;
  TextEditingController email;
  TextEditingController phone;
  TextEditingController address;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = true;
  Map<String, dynamic> response;
  @override
  void initState() {
    super.initState();
    username = new TextEditingController(text: widget.user.username);
    bio = new TextEditingController(text: widget.user.bio);
    fName = new TextEditingController(text: widget.user.fName);
    lName = new TextEditingController(text: widget.user.lName);
    email = new TextEditingController(text: widget.user.email);
    phone = new TextEditingController(text: widget.user.phoneNo);
    address = new TextEditingController(text: widget.user.address);
  }

  submitHandler() {
    if (_formKey.currentState.validate()) {
      Map<String, dynamic> userUpdates = {
        "username": username.text,
        "bio": bio.text,
        "fName": fName.text,
        "lName": lName.text,
        "email": email.text,
        "phoneNo": phone.text,
        "address": address.text
      };
      UserService userService = getIt.get<UserService>();
      userService.updateUser(userUpdates).then((res) {
        print(res);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(30),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 15, spreadRadius: 100)
            ]),
        child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //top section(box title and close button)
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.settings,
                                    color: Colors.deepPurple[300]),
                                SizedBox(width: 10),
                                Text("Change Profile",
                                    style: TextStyle(
                                        color: Colors.deepPurple[300],
                                        fontFamily: "Titil",
                                        fontSize: 20))
                              ],
                            )),
                          ),
                          Container(
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: FlatButton(
                                  onPressed: () {
                                    widget.toggleChangeProfile();
                                  },
                                  child: Icon(Icons.close,
                                      color: Colors.red[300]))),
                        ],
                      ),
                      SizedBox(height: 30),

                      new TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType
                              .text, // Use email input type for emails.
                          controller: username,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.person_pin_circle),
                            labelText: "Username",
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: '${widget.user.username}',
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      new TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType
                              .text, // Use email input type for emails.
                          controller: bio,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.person_pin_circle),
                            labelText: "Bio",
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: '${widget.user.bio}',
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      new TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType
                              .text, // Use email input type for emails.
                          controller: fName,
                          validator: (val) => val.length < 6
                              ? 'Atleast six character required'
                              : null,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.person_pin_circle),
                            labelText: "First Name",
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: '${widget.user.fName}',
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      new TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType
                              .text, // Use email input type for emails.
                          controller: lName,
                          validator: (val) => val.length < 6
                              ? 'Atleast six character required'
                              : null,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.person_pin_circle),
                            labelText: "Last Name",
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: '${widget.user.lName}',
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      new TextFormField(
                          keyboardType: TextInputType
                              .emailAddress, // Use email input type for emails.
                          controller: email,
                          validator: (val) =>
                              !val.contains('@') ? 'Not a valid email' : null,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.email),
                            labelText: "Email",
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: '${widget.user.email}',
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      new TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType
                              .phone, // Use email input type for emails.
                          controller: phone,
                          validator: (val) => val.length == 10
                              ? null
                              : "phone no requires 10 digits",
                          decoration: new InputDecoration(
                            icon: Icon(Icons.phone),
                            labelText: "Phone_no",
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: '${widget.user.phoneNo}',
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      new TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType
                              .text, // Use email input type for emails.
                          controller: address,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.home),
                            labelText: "Address",
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: '${widget.user.address}',
                          )),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: FlatButton(
                              color: Colors.green[300],
                              onPressed: () {
                                submitHandler();
                              },
                              child: Center(
                                  child: Text("Submit",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Titil",
                                          fontSize: 20))))),
                    ]))));
  }
}
