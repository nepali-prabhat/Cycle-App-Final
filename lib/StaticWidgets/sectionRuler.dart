import 'package:flutter/material.dart';
class SectionRuler extends StatelessWidget {
  final String section;
  final Color color;
  SectionRuler({this.section, this.color});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Divider(
          color: color,
        )),
        SizedBox(width: 5),
        Text(
          section,
          style: TextStyle(
              color: color, fontSize: 20, fontFamily: 'Ubuntu'),
        ),
        SizedBox(width: 5),
        Expanded(
            child: Divider(
          color: color,
        )),
      ],
    );
  }
}
