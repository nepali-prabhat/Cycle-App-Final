import 'package:flutter/material.dart';

class ShapeOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: Design(),
      child: Container(
        height: 140.0,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.deepOrangeAccent.withOpacity(0.5),
          Colors.white.withOpacity(0.5),
        ])),
      ),
    );
  }
}

class Design extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    final Path path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);

    var firstendpoint = Offset(size.width - 120, size.height - 60);
    var firstcontrolpoint = Offset(size.width - 50, size.height - 50);

    path.quadraticBezierTo(firstcontrolpoint.dx, firstcontrolpoint.dy,
        firstendpoint.dx, firstendpoint.dy);

    var secondendpoint = Offset(size.width * 0.25, 0.0);
    var secondcontrolpoint = Offset(size.width - 220, size.height - 80);

    path.quadraticBezierTo(secondcontrolpoint.dx, secondcontrolpoint.dy,
        secondendpoint.dx, secondendpoint.dy);
    // path.lineTo(size.width * 0.25, 0.0);
    path.close();

    // path.close();
    // var firstendpoint = Offset(size.width * 0.25, size.height - 80.0);
    // var firstcontrolpoint = Offset(size.widtSh * 0.65, size.height - 100.0);
    // path.quadraticBezierTo(firstcontrolpoint.dx, firstcontrolpoint.dy,
    //     firstendpoint.dx, firstendpoint.dy);

    // var secondendpoint = Offset(size.height, size.width);
    // var secondcontrolpoint = Offset(size.width * 0.15, size.height - 50.0);
    // path.quadraticBezierTo(secondcontrolpoint.dx, secondcontrolpoint.dy,
    //     secondendpoint.dx, secondendpoint.dy);

    // path.lineTo(size.width, 0.0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
