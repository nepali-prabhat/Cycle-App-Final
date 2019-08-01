import 'package:cycle_app/Home/pages/EventsPage/eventsFeed.dart';
import 'package:cycle_app/Home/pages/EventsPage/myEvents.dart';
import 'package:cycle_app/StaticWidgets/sectionRuler.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cycle_app/Service/eventService.dart';
import 'package:toast/toast.dart';

class EventPage extends StatefulWidget {
  final Function toggleCollapse;
  final Function changeActiveIndex;
  final bool collapsedState;
  EventPage(
      {Key key,
      this.toggleCollapse,
      this.collapsedState,
      this.changeActiveIndex})
      : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  TextEditingController name = new TextEditingController();
  TextEditingController description = new TextEditingController();
  int _currentIndex = 0;
  DateTime _date = DateTime.now();
  DateTime _dateEnd = DateTime.now();
  TimeOfDay _time = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _timeEnd = TimeOfDay(hour: 0, minute: 0);
  resetFields() {
    name.clear();
    description.clear();
    _date = DateTime.now();
    _dateEnd = DateTime.now();
    _time = TimeOfDay(hour: 0, minute: 0);
    _timeEnd = TimeOfDay(hour: 0, minute: 0);
  }

  Future<Null> showDate(context, type) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: _date,
        lastDate: _date.add(Duration(days: 365 * 8)));
    if (picked != null) {
      setState(() {
        if (type == 'start') {
          _date = picked;
        }
        if (type == 'end') {
          _dateEnd = picked;
        }
      });
    }
  }

  Future<Null> showTime(context, type) async {
    final TimeOfDay timePicked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if (timePicked != null) {
      setState(() {
        if (type == 'start') {
          _time = timePicked;
        }
        if (type == 'end') {
          _timeEnd = timePicked;
        }
      });
    }
  }

  getDateTimeCombined(type) {
    if (type == 'start') {
      DateTime combinedDateTime = DateTime(
          _date.year, _date.month, _date.day, _time.hour, _time.minute);
      return combinedDateTime;
    }
    if (type == 'end') {
      DateTime combinedDateTime = DateTime(_dateEnd.year, _dateEnd.month,
          _dateEnd.day, _timeEnd.hour, _timeEnd.minute);
      return combinedDateTime;
    }
  }

  Widget buildAddEvent(context) {
    DateTime eventStart = getDateTimeCombined('start');
    DateTime eventend = getDateTimeCombined('end');
    return Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            SizedBox(height: 15),
            SectionRuler(section: "name of event", color: Colors.grey),
            TextFormField(
                controller: name,
                decoration: new InputDecoration(
                  icon: Icon(Icons.event),
                  labelText: "Name",
                  contentPadding: EdgeInsets.all(10.0),
                )),
            SizedBox(height: 30),
            SectionRuler(section: "description of event", color: Colors.grey),
            TextFormField(
                controller: description,
                decoration: new InputDecoration(
                  icon: Icon(Icons.event_note),
                  labelText: "description",
                  contentPadding: EdgeInsets.all(10.0),
                )),
            SizedBox(height: 30),
            SectionRuler(section: "start of event", color: Colors.grey),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                    color: Colors.red[200],
                    child: Text('${eventStart.toString().split(' ')[0]}'),
                    onPressed: () {
                      showDate(context, 'start');
                    }),
                RaisedButton(
                    color: Colors.red[100],
                    child: Text(
                        '${eventStart.toString().split(' ')[1].substring(0, 5)}'),
                    onPressed: () {
                      showTime(context, 'start');
                    }),
              ],
            ),
            SizedBox(height: 30),
            SectionRuler(section: "end of event", color: Colors.grey),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                    color: Colors.red[200],
                    child: Text('${eventend.toString().split(' ')[0]}'),
                    onPressed: () {
                      showDate(context, 'end');
                    }),
                RaisedButton(
                    color: Colors.red[100],
                    child: Text(
                        '${eventend.toString().split(' ')[1].substring(0, 5)}'),
                    onPressed: () {
                      showTime(context, 'end');
                    }),
              ],
            ),
            SizedBox(height: 30),
            RaisedButton(
                color: Colors.green[200],
                child: Text('add event'),
                onPressed: () async {
                  String response = await postEvent(name.text, description.text,
                      eventStart.toString(), eventend.toString());
                  Toast.show("$response", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  if (response == "event successfuly posted.") {
                    resetFields();
                  }
                })
          ],
        ));
  }

  getpagesBasedOnIndex() {
    if (_currentIndex == 0) {
      return EventsFeed();
    }
    if (_currentIndex == 1) {
      return MyEvents(changeActiveIndex: widget.changeActiveIndex);
    }
    if (_currentIndex == 2) {
      return buildAddEvent(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        child: SafeArea(
            child: Scaffold(
          body: SingleChildScrollView(child: getpagesBasedOnIndex()),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                if (_currentIndex != index) {
                  _currentIndex = index;
                }
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.account_balance),
                title: new Text('Events Feed'),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.event_available),
                title: new Text('My Events'),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.add_box),
                title: new Text('Add Event'),
              ),
            ],
          ),
        )),
      ),
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
