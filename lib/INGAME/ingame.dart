import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../GamePage/initfragen.dart';
import '../Helper/globals.dart';
import 'ResulToSocket.dart';

class InGame extends StatefulWidget {
  final List<CFragen>? CFragenList;
  final String? gameguid;

  const InGame({Key? key, this.CFragenList, this.gameguid}) : super(key: key);

  @override
  State<InGame> createState() => _InGameState();
}

class _InGameState extends State<InGame> {
  void antwortCheck(String antwort) async {
    if (widget.CFragenList![gameindex].RichtigeAntwort == antwort) {
      gamepunkte++;
      print("Richtig");
    }
    if (gameindex == 3) {
      Prefs prefsget = await getPrefs();
      // ignore: use_build_context_synchronously
      if (gameover == false) {
        resultToWebsocket(prefsget.playerguid, gamepunkte.toString(),
            widget.gameguid!, context, "warte");
        gameover = true;
      }
    } else {
      setState(() {
        gameindex++;
      });
    }
  }

  int gameindex = 0;
  int gamepunkte = 0;
  bool gameover = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.CFragenList);

    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(50.0),
          child: Container(
            width: 400,
            height: 200,
            color: Colors.cyan,
            child: Text(widget.CFragenList![gameindex].Frage),
          ),
        ),
        //4
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: GestureDetector(
            onTap: () {
              antwortCheck(widget.CFragenList![gameindex].Antwort1);
            },
            child: Container(
              width: 400,
              height: 100,
              color: Colors.cyan,
              child: Text(widget.CFragenList![gameindex].Antwort1),
            ),
          ),
        ),

        //2
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: GestureDetector(
            onTap: () {
              antwortCheck(widget.CFragenList![gameindex].Antwort2);
            },
            child: Container(
              width: 400,
              height: 100,
              color: Colors.cyan,
              child: Text(widget.CFragenList![gameindex].Antwort2),
            ),
          ),
        ),

        //3
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: GestureDetector(
            onTap: () {
              antwortCheck(widget.CFragenList![gameindex].Antwort3);
            },
            child: Container(
              width: 400,
              height: 100,
              color: Colors.cyan,
              child: Text(widget.CFragenList![gameindex].Antwort3),
            ),
          ),
        ),

        //4
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: GestureDetector(
            onTap: () {
              antwortCheck(widget.CFragenList![gameindex].Antwort4);
            },
            child: Container(
              width: 400,
              height: 100,
              color: Colors.cyan,
              child: Text(widget.CFragenList![gameindex].Antwort4),
            ),
          ),
        ),
      ],
    ));
  }
}
