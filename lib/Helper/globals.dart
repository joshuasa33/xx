import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Globals {
  Color mainColor = Color.fromRGBO(242, 233, 0, 1);
  Color secondColor = Color.fromRGBO(73, 255, 200, 1);
  Color thirdColor = Colors.black;
  Color fourthColor = Color.fromARGB(161, 212, 0, 205);
  Color fourthLight = Color.fromARGB(112, 212, 0, 205);
}

// Color mainColor = Color.fromRGBO(92, 27, 223, 0.773);

Future<Prefs> getPrefs() async {
  Prefs obj = Prefs();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("playerguid")) {
    obj.playerguid = prefs.getString("playerguid")!;
  }
  return obj;
}

class Prefs {
  String playerguid = "0";
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height * 0.75);
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height * 0.25);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
