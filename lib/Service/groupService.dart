import 'dart:async';
import 'package:cycle_app/Model/groupModel.dart';
import 'package:cycle_app/globals.dart';
import 'package:cycle_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:cycle_app/Model/UserModel.dart';
import 'package:cycle_app/Model/messageModel.dart';
import 'package:cycle_app/Model/myEventsModel.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';
import 'package:cycle_app/Service/userService.dart';

class GroupService {
  BehaviorSubject<MyEventsModel> _event;
  MyEventsModel get event => _event.value;
  Observable<MyEventsModel> get event$ => _event.stream;

  BehaviorSubject<GroupModel> _group;
  GroupModel get group => _group.value;
  Observable<GroupModel> get group$ => _group.stream;

  BehaviorSubject<List<MessageModel>> _message;
  List<MessageModel> get message => _message.value;
  Observable<List<MessageModel>> get message$ => _message.stream;

  BehaviorSubject<List<UserModel>> _participants;
  List<UserModel> get participants => _participants.value;
  Observable<List<UserModel>> get participants$ => _participants.stream;

  BehaviorSubject<int> _updater;
  int get updater => _updater.value;
  Observable<int> get updater$ => _updater.stream;

  BehaviorSubject<bool> _willUpdate;
  bool get willUpdate => _willUpdate.value;
  Observable<bool> get willUpdate$ => _willUpdate.stream;

  void setWillUpdate(bool newWillUpdate) {
    _willUpdate.add(newWillUpdate);
  }

  Timer _updateTimer;

  GroupService() {
    _event = new BehaviorSubject<MyEventsModel>();
    _message = new BehaviorSubject<List<MessageModel>>.seeded([]);
    _updater = new BehaviorSubject<int>.seeded(1);
    _group = new BehaviorSubject<GroupModel>();
    _participants = new BehaviorSubject();
    _willUpdate = new BehaviorSubject.seeded(false);

    _updateTimer =
        new Timer.periodic(Duration(milliseconds: 1300), (Timer timer) {
      if (willUpdate) {
        addMessageByFetching(group.id);
      }
    });
  }
  void addEvent(MyEventsModel event) async {
    _event.add(event);
    http.Response response = await http.get('$base_url/groups/of/${event.id}',
        headers: {
          "Authorization": "Bearer ${getIt.get<UserService>().tokenValue}"
        });
    if (response.statusCode == 200) {
      //success
      GroupModel group = groupModelFromJson(response.body);
      _addGroup(group);
      _addParticipant();
      addMessageByFetching(group.id);
    } else {}
  }

  void resetMessage() {
    _message.add([]);
  }

  _addParticipant() {
    List<UserModel> tempParticipants;
    event.participants.forEach((participant) {
      tempParticipants.insert(0, UserModel.fromJson(json.encode(participant)));
      _participants.add(tempParticipants);
    });
  }

  void addMessageByFetching(int groupId) async {
    print('addMessage by fetching');
    http.Response response = await http.get('$base_url/messages/${groupId}',
        headers: {
          "Authorization": "Bearer ${getIt.get<UserService>().tokenValue}"
        });
    if (response.statusCode == 200) {
      List<MessageModel> msg = messageModelFromJson(response.body);
      if (message.length > 0) {
        if (msg[0].id != message[0].id) {
          _message.add(msg);
          print(['true', msg[0].id, message[0].id, groupId]);
        } else {
          print(["false", msg[0].id, message[0].id, groupId]);
        }
      } else {
        _message.add(msg);
      }
    }
  }

  void _addGroup(GroupModel group) {
    _group.add(group);
  }

  void update() {
    _updater.add(updater + 1);
  }
}
