import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cycle_app/Model/UserModel.dart';
import 'package:cycle_app/globals.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  BehaviorSubject<bool> _isLoggedIn;
  BehaviorSubject<UserModel> _user;
  BehaviorSubject<String> _token;

  UserService() {
    _isLoggedIn = new BehaviorSubject<bool>.seeded(false);
    _user = new BehaviorSubject<UserModel>();
    _token = new BehaviorSubject<String>();
    _readUserFromLocalStore();
  }

  //observable and current value of the subjects
  Observable<bool> get isLoggedIn$ => _isLoggedIn.stream;
  bool get isLoggedInValue => _isLoggedIn.value;

  Observable<UserModel> get user$ => _user.stream;
  UserModel get userValue => _user.value;

  Observable<String> get token$ => _token.stream;
  String get tokenValue => _token.value;

  void changePermission(value) {
    if (value == true) {
      UserModel newUserModel = _user.value;
      newUserModel.permission = 1;
      _user.add(newUserModel);
    } else {
      UserModel newUserModel = _user.value;
      newUserModel.permission = 0;
      _user.add(newUserModel);
    }
    _saveUserToLocalStore();
    //todo:handle database query

    http.put('$base_url/users/permission',
        body: {'permission': '${userValue.permission}'},
        headers: {"Authorization": "Bearer " + tokenValue}).then((response) {
      //   print("changed permission.");
      print(response.body);
    });
  }

  Future<Map<String, dynamic>> authenticate(
      {String username, String password}) async {
    final String loginURL = base_url + "/login";

    var client = new http.Client();

    try {
      var response = await client.post(
        loginURL,
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        _isLoggedIn.add(true);
        Map<String, dynamic> body = jsonDecode(response.body);
        print(body);
        // updating the current data in the service.
        var responseUser = UserModel.fromMap(body['user']);
        _user.add(responseUser);
        _token.add(body["token"]);
        _isLoggedIn.add(true);
        //saving the user data of the service
        _saveUserToLocalStore();
        return body;
      } else {
        throw (jsonDecode(response.body));
      }
    } catch (error) {
      return error;
    }
  }

  Future<Map<String, dynamic>> updateUser(
      Map<String, dynamic> userUpdates) async {
    Map<String, dynamic> body = {};
    if (userValue.username != userUpdates['username']) {
      body['username'] = userUpdates['username'];
    }

    if (userValue.bio != userUpdates['bio']) {
      body['bio'] = userUpdates['bio'];
    }

    if (userValue.fName != userUpdates['fName']) {
      body['f_name'] = userUpdates['fName'];
    }

    if (userValue.lName != userUpdates['lName']) {
      body['l_Name'] = userUpdates['lName'];
    }

    if (userValue.email != userUpdates['email']) {
      body['email'] = userUpdates['email'];
    }

    if (userValue.phoneNo != userUpdates['phoneNo']) {
      body['phone_no'] = userUpdates['phoneNo'];
    }
    if (userValue.address != userUpdates['address']) {
      body['address'] = userUpdates['address'];
    }
    try {
      var response = await http.post('$base_url/users/${userValue.id}/update',
          body: body, headers: {'Authorization': "Bearer " + tokenValue});

      if (response.statusCode == 200) {
        _isLoggedIn.add(true);
        Map<String, dynamic> body = jsonDecode(response.body);
        // updating the current data in the service.
        var responseUser = UserModel.fromMap(body['user']);
        _user.add(responseUser);
        _isLoggedIn.add(true);
        //saving the user data of the service
        _saveUserToLocalStore();
        return body;
      } else {
        throw (jsonDecode(response.body));
      }
    } catch (error) {
      return error;
    }
  }

  void logOut() {
    _isLoggedIn.add(false);
    _user.add(null);
    _token.add("");
    _deleteFromLocalStorage();
  }

  void _saveUserToLocalStore() {
    SharedPreferences.getInstance().then((pref) {
      pref.setString('token', tokenValue);
      print(userValue.toJson() is String);
      pref.setString('user', userValue.toJson());
      pref.setBool('isLogged', true);
    });
  }

  void _readUserFromLocalStore() {
    SharedPreferences.getInstance().then((pref) {
      if (pref.containsKey('isLogged')) {
        _token.add(pref.getString('token'));
        print(pref.get('user'));
        _user.add(UserModel.fromJson(pref.getString('user')));
        _isLoggedIn.add(pref.getBool('isLogged'));
      }
    });
  }

  void _deleteFromLocalStorage() {
    SharedPreferences.getInstance().then((pref) {
      pref.remove('isLogged');
      pref.remove('token');
      pref.remove('user');
    });
  }
}
