import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cycle_app/globals.dart';
import 'package:http/http.dart' as http;

class Data {
  String username;
  String email;
  String password;
  String phone_no;
  String address;
  Data({this.username, this.email, this.password, this.phone_no, this.address});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone_no: json['phone_no'] as String,
      address: json['address'] as String,
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["email"] = email;
    map["password"] = password;
    map["phone_no"] = phone_no;
    map["address"] = address;

    return map;
  }
}

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: new Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Register Your Account",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          FloatingActionButton(
              child: Icon(Icons.person_outline),
              backgroundColor: Colors.redAccent,
              onPressed: () => {_scaffoldKey.currentState.openEndDrawer()})
        ],
      ),
      body: MainForm(),
    );
  }
}

///main registration form
class MainForm extends StatefulWidget {
  @override
  _MainFormState createState() => _MainFormState();
}

class _MainFormState extends State<MainForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool sendPostRequest = false;
  bool success = false;

  final String signUpURL = '$base_url/signup';

  TextEditingController username = new TextEditingController();
  TextEditingController fName = new TextEditingController();
  TextEditingController lName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController address = new TextEditingController();

  Future<Map<String, dynamic>> createPost() async {
    var response = await http.post(signUpURL, body: {
      "username": username.text,
      "f_name": fName.text,
      "l_name": lName.text,
      "email": email.text,
      "password": password.text,
      "phone_no": phone.text,
      "address": address.text,
      "permission": '0',
      "bio": "Namastae, i am ${username.text}."
    });
    var jsonData = json.decode(response.body);
    return jsonData;
  }

  _MainFormState({Key key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Material(
            elevation: 1.0,
            child: Container(
              // scolor: Colors.white.withOpacity(0.6),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
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
                            hintText: 'you@example.com',
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      new TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType
                              .text, // Use email input type for emails.
                          controller: username,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.person_pin_circle),
                            labelText: "Username",
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: 'karunkop',
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
                            hintText: 'Karun',
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
                            hintText: 'Pandey',
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
                            hintText: '+977 9861538501',
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      new TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType
                              .text, // Use email input type for emails.
                          controller: password,
                          validator: (val) => val.length < 6
                              ? 'Atleast six character required'
                              : null,
                          obscureText: true,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.vpn_key),
                            labelText: "Password",
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: 'Password',
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
                            hintText: '28 kilo , Dhulikhel',
                          )),
                      SizedBox(
                        height: 25,
                      ),
                      Builder(
                        builder: (context) => GestureDetector(
                              onTap: () {
                                if (_formKey.currentState.validate()) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: FutureBuilder(
                                        future: createPost(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Text("Loaading...");
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                  "Something went Wrong");
                                            } else if (snapshot.hasData) {
                                              var response = snapshot.data;

                                              for (var value
                                                  in response.values) {
                                                var edited = value ==
                                                        "Registration successfull"
                                                    ? value.toString()
                                                    : value
                                                        .toString()
                                                        .substring(
                                                            1,
                                                            value
                                                                    .toString()
                                                                    .length -
                                                                1);
                                                return Text(
                                                  edited,
                                                  style: response['mssg'] ==
                                                          "Registration successfull"
                                                      ? TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 15,
                                                          fontFamily:
                                                              "Roboto-Light.ttf",
                                                        )
                                                      : TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 15,
                                                          fontFamily:
                                                              "Roboto-Light.ttf",
                                                        ),
                                                );
                                              }
                                            }
                                          }
                                        }),
                                  ));
                                } else {
                                  setState(() {
                                    _autoValidate = true;
                                  });
                                }
                              },
                              child: new Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 100),
                                decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.red,
                                        offset: Offset(1.0, 6.0),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
