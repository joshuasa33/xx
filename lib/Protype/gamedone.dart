import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lottie/lottie.dart';

class GameDone extends StatefulWidget {
  const GameDone({super.key});

  @override
  State<GameDone> createState() => _GameDoneState();
}

class _GameDoneState extends State<GameDone> {
  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(children: [
        SizedBox(
          height: 200,
        ),
        Container(
          width: maxWidth,
          height: maxHeight * 0.1,
          color: Colors.amber,
          child: Center(
            child: Text(
              "Waiting for results",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 41, 11, 234),
              ),
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                maxWidth * 0.15, maxHeight * 0.02, maxWidth * 0.15, 0),
            child: Container(
              height: maxHeight * 0.08,
              width: double.maxFinite,
              child: Lottie.asset('lib/images/97443-loading-gray.json'),
            ),
          ),
        ),
        Container(
          width: maxWidth,
          height: maxHeight * 0.1,
          color: Colors.amber,
          child: Center(
            child: Text(
              "Das Ergebnis",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 41, 11, 234),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
