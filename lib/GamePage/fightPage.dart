// ignore_for_file: sized_box_for_whitespace

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:testre/Helper/globals.dart';
import '../Helper/httpMetaData.dart';
import '../INGAME/reskin.dart';
import 'GamePage.dart';
import 'StartSocket.dart';

class FightPage extends StatefulWidget {
  const FightPage({super.key});

  @override
  State<FightPage> createState() => _FightPageState();
}

class _FightPageState extends State<FightPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Globals objglobals = Globals();
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;

    return Container(
      child: Column(children: [
        //Top Header
        Padding(
          padding: EdgeInsets.fromLTRB(
              maxWidth * 0.0, maxHeight * 0.078, maxWidth * 0.0, 0),
          child: Container(
            decoration: BoxDecoration(
              color: objglobals.secondColor,
              border: Border(
                top: BorderSide(
                  width: maxHeight * 0.003,
                  color: Colors.black,
                  style: BorderStyle.solid,
                ),
                bottom: BorderSide(
                  width: maxHeight * 0.003,
                  color: Colors.black,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            height: maxHeight * 0.05,
            width: double.maxFinite,
            child: Padding(
              padding: EdgeInsets.only(left: maxWidth * 0.01),
              child: Container(
                height: maxHeight,
                width: maxWidth * 0.6,
                child: AutoSizeText(
                  context.watch<PlayerName>().playerName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    'Orbitron', // Replace with your desired Google Font
                    textStyle:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
        ),

        //ELO SHOW
        Padding(
          padding:
              EdgeInsets.fromLTRB(maxWidth * 0.75, maxHeight * 0.035, 0, 0),
          child: Container(
            height: maxHeight * 0.025,
            width: maxWidth,
            child: Row(
              children: [
                Container(
                  width: maxWidth * 0.06,
                  height: maxHeight * 0.0225,
                  child: Image.asset('lib/Icons/trophy.png'),
                ),
                Container(
                  height: maxHeight,
                  width: maxWidth * 0.135,
                  child: AutoSizeText(
                    context.watch<PlayerElo>().playerElo,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.getFont(
                      'Orbitron', // Replace with your desired Google Font
                      textStyle: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

        // Character Model
        Padding(
          padding:
              EdgeInsets.fromLTRB(maxWidth * 0.065, 0, maxWidth * 0.065, 0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: maxHeight * 0.0075, // adjust border thickness as desired
                color: Colors.black, // choose border color
                style: BorderStyle.solid,
                // choose border style
              ),
            ),
            width: maxWidth,
            height: maxHeight * 0.43,
            child: Stack(
              children: [
                Container(
                  width: maxWidth,
                  height: maxHeight,
                  child: Image.asset(
                    context.watch<BGPath>().bgPath,
                    fit: BoxFit.fill,
                  ),
                ),
                ModelViewer(
                  src: context.watch<ModelPath>().modelPath,
                  alt: 'My 3D Model',
                  ar: false, // Enable AR mode
                  autoRotate: false, // Enable auto-rotation
                  cameraControls: true, // Enable camera controls
                  disableTap: true,
                  disablePan: true,
                ),
              ],
            ),
          ),
        ),

        // Start Game
        GestureDetector(
          onTap: () async {
            Prefs prefsget = await getPrefs();
            try {
              connectToWebSocket(prefsget.playerguid, "100", context);
            } catch (E) {
              print("e");
            }
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                maxWidth * 0.15, maxHeight * 0.02, maxWidth * 0.15, 0),
            child: Container(
              decoration: BoxDecoration(
                color: objglobals.secondColor,
                border: Border.all(
                  width:
                      maxHeight * 0.0075, // adjust border thickness as desired
                  color: Colors.black, // choose border color
                  style: BorderStyle.solid,
                  // choose border style
                ),
              ),
              height: maxHeight * 0.14,
              width: double.maxFinite,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: maxHeight * 0.025),
                    child: Container(
                      width: maxWidth * 0.66,
                      height: maxHeight * 0.07,
                      child: const AutoSizeText("PLAY",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 55,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Cyberthic')),
                    ),
                  ),
                  //Load
                  Visibility(
                    visible: context.watch<SearchSocket>().state,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          maxWidth * 0.51, maxHeight * 0.017, 0, 0),
                      child: Container(
                        height: maxHeight * 0.08,
                        width: double.maxFinite,
                        child: Lottie.asset(
                            'lib/images/97443-loading-gray.json'), //thefuture
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class SearchSocket extends ChangeNotifier {
  bool state = false;

  void setTrue() {
    state = true;
    notifyListeners();
    print("true");
  }

  void setFalse() {
    state = false;
    notifyListeners();
    print("false");
  }
}

class PlayerName extends ChangeNotifier {
  String playerName = "";

  void updatePlayer(String getName) {
    playerName = getName;
    notifyListeners();
  }
}

class PlayerElo extends ChangeNotifier {
  String playerElo = "";

  void updatePlayer(String getElo) {
    playerElo = getElo;
    notifyListeners();
  }
}

class PlayerMoney extends ChangeNotifier {
  String playerMoney = "";

  void updatePlayer(String getName) {
    playerMoney = getName;
    notifyListeners();
  }
}

class ModelPath extends ChangeNotifier {
  String modelPath = "3DModels/Pilzi.glb";

  void changePath(getPath) {
    modelPath = getPath;
    notifyListeners();
  }
}

class BGPath extends ChangeNotifier {
  String bgPath = "Backgrounds/BG00.jpg";

  void changePath(getPath) {
    bgPath = getPath;
    notifyListeners();
  }
}
