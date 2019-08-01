import 'package:cycle_app/Service/userService.dart';
import 'package:cycle_app/main.dart';
import 'package:flutter/material.dart';
import './Registration.dart';
import './customShapes/shapeOne.dart';
import './customShapes/shapeThree.dart';
import './customShapes/shapeTwo.dart';

class NewLogin extends StatefulWidget {
  @override
  _NewLoginState createState() => _NewLoginState();
}

class _NewLoginState extends State<NewLogin> {
  final UserService userService = getIt.get<UserService>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'assets/images/Test.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                    Colors.deepOrangeAccent.withOpacity(0.5),
                    Colors.orangeAccent.withOpacity(0.3),
                  ],
                      stops: [
                    0.0,
                    1.0
                  ])),
            ),
            ShapeThree(),
            ShapeTwo(),
            ShapeOne(),
            AnimatedPositioned(
              duration: Duration(milliseconds: 1),
              top: MediaQuery.of(context).size.height * 0.25,
              left: MediaQuery.of(context).size.width * 0.35,
              child: Container(
                height: 125,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              new TextFormField(
                                  keyboardType: TextInputType
                                      .text, // Use email input type for emails.
                                  controller: username,
                                  decoration: new InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.black26,
                                        width: 2.0,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    prefixIcon: Icon(Icons.email),
                                    labelText: "Username",
                                    contentPadding: EdgeInsets.all(15.0),
                                    hintText: 'karunkop',
                                  )),
                              SizedBox(
                                height: 50,
                              ),
                              new TextFormField(
                                  autofocus: false,
                                  // Use secure text for passwords.
                                  controller: password,
                                  obscureText: true,
                                  decoration: new InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.black26,
                                        width: 2.0,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    prefixIcon: Icon(Icons.vpn_key),
                                    labelText: "Password",
                                    prefixStyle: TextStyle(color: Colors.grey),
                                    hintText: 'Password',
                                    contentPadding: EdgeInsets.all(15.0),
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              InkWell(
                                onTap: () {},
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 30),
                              new ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(80)),
                                  child: Builder(
                                    builder: (context) => RaisedButton(
                                          elevation: 4.0,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 30),
                                          onPressed: () {
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              content: FutureBuilder(
                                                future:
                                                    userService.authenticate(
                                                        username: username.text,
                                                        password:
                                                            password.text),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Text('Loading');
                                                  }
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    if (snapshot.hasError) {
                                                      return Text(
                                                          'Unable to login due to some errors');
                                                    } else {
                                                      var response =
                                                          snapshot.data;

                                                      return Text(
                                                        response['mssg'],
                                                        style: response[
                                                                    'mssg'] ==
                                                                "Login successfull"
                                                            ? TextStyle(
                                                                color: Colors
                                                                    .green)
                                                            : TextStyle(
                                                                color:
                                                                    Colors.red),
                                                      );
                                                    }
                                                  }
                                                },
                                              ),
                                              duration: Duration(seconds: 3),
                                            ));
                                          },
                                          color: Colors.red.withOpacity(0.7),
                                          child: Text("Login",
                                              style: TextStyle(
                                                  fontFamily: "CustomFont",
                                                  fontSize: 25,
                                                  color: Colors.white)),
                                        ),
                                  )),
                              SizedBox(
                                height: 50.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 150.0,
                  child: ClipPath(
                    clipper: Design(),
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                      height: 200.0,
                    ),
                  ),
                )
              ],
            )
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Register here",
          onPressed: () {},
          backgroundColor: Colors.red,
          child: IconButton(
              onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Registration()));
          },
            icon: Icon(
                
              Icons.recent_actors,
              color: Colors.white,
            ),
          ),
        ));
  }
}

class Design extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    final Path path = Path();
    path.lineTo(0.0, size.height);

    path.lineTo(size.width * 0.5, size.height);

    var firstendpoint = Offset(0.0, 0.0);
    var firstcontrolpoint = Offset(size.width / 2 * 0.25, size.height / 2);

    path.quadraticBezierTo(firstcontrolpoint.dx, firstcontrolpoint.dy,
        firstendpoint.dx, firstendpoint.dy);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
