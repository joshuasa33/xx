// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';
import 'package:testre/Helper/httpMetaData.dart';
import 'package:testre/ShopPage/shopFile.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:testre/GamePage/GamePage.dart';
import 'package:testre/GamePage/initfragen.dart';
import 'package:testre/Protype/gamedone.dart';

import '../GamePage/fightPage.dart';
import '../Helper/globals.dart';
import 'ResulToSocket.dart';

int timeLeft = 3;
bool lastTime = false;

class ReSkin extends StatefulWidget {
  final List<CFragen>? CFragenList;
  final String? gameguid;

  const ReSkin({Key? key, this.CFragenList, this.gameguid}) : super(key: key);

  @override
  State<ReSkin> createState() => _ReSkinState();
}

class _ReSkinState extends State<ReSkin> {
  void _startCountDown() {
    timeLeft = 60;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          timeLeft--;
          if (gameover) {
            timer.cancel();
            return;
          }
          if (timeLeft == 0) {
            timer.cancel();
            canAnswer = false;
            gameover = true;
            proceedResult();
            lastCounterReTry();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  void lastCounterReTry() {
    int lastCounterTimeLeft = 6;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        lastCounterTimeLeft--;
        print(lastCounterTimeLeft);
        if (lastCounterTimeLeft == 0) {
          timer.cancel();
          print("Last Try");
          lastTime = true;
          proceedResult(lastTry: true);
        } else {
          timer.cancel();
        }
      }
    });
  }

  void falldone() async {
    await Future.delayed(const Duration(seconds: 1));
    GameFinish gameFinish = GameFinish();
    String ergebnisValue = gameFinish.ergebnis;
    print("$ergebnisValue:Das Hier");
    if (mounted) {
      setState(() {
        alldone = true;
      });
    }
  }

  void proceedResult({bool lastTry = false}) async {
    if (retriveResult == false) {
      Prefs prefsget = await getPrefs();
      retriveResult == true;
      resultToWebsocket(prefsget.playerguid, richtigeAntworten.toString(),
          widget.gameguid!, context, "fertig",
          lasttry: lastTry);
    }
  }

  void proceedAnswer(String antwort, int colorindex) async {
    if (canAnswer) {
      if (antwort == widget.CFragenList![index].RichtigeAntwort) {
        richtigeAntworten++;
        Prefs prefsget = await getPrefs();

        // Update TO WS
        // ignore: use_build_context_synchronously
        if (index < 3) {
          // ignore: use_build_context_synchronously
          resultToWebsocket(prefsget.playerguid, richtigeAntworten.toString(),
              widget.gameguid!, context, "warte");
        }

        if (mounted) {
          setState(() {
            canAnswer = false;
            colors[colorindex] = Colors.green;
          });
        }
      }
      //
      else {
        Prefs prefsget = await getPrefs();
        if (mounted) {
          setState(() {
            canAnswer = false;
            print("falsch re");
            if (widget.CFragenList![index].Antwort1 ==
                widget.CFragenList![index].RichtigeAntwort) {
              colors[0] = Colors.green;
            }
            if (widget.CFragenList![index].Antwort2 ==
                widget.CFragenList![index].RichtigeAntwort) {
              colors[1] = Colors.green;
            }
            if (widget.CFragenList![index].Antwort3 ==
                widget.CFragenList![index].RichtigeAntwort) {
              colors[2] = Colors.green;
            }
            if (widget.CFragenList![index].Antwort4 ==
                widget.CFragenList![index].RichtigeAntwort) {
              colors[3] = Colors.green;
            }
            colors[colorindex] = Colors.red;
          });
        }
      }

      await Future.delayed(const Duration(milliseconds: 2000));
      if (mounted) {
        setState(() {
          for (int i = 0; i < colors.length; i++) {
            colors[i] = const Color.fromRGBO(73, 255, 200, 1);
          }
          if (index < 3) {
            index++;
            canAnswer = true;
          } else {
            setState(() {
              gameover = true;
              lastCounterReTry();
            });
            proceedResult();
          }
        });
      }
    }
  }

  bool canAnswer = true;
  bool gameover = false;
  int index = 0;
  int richtigeAntworten = 0;
  bool retriveResult = false;
  bool alldone = false;
  List<Color> colors = [
    const Color.fromRGBO(73, 255, 200, 1),
    const Color.fromRGBO(73, 255, 200, 1),
    const Color.fromRGBO(73, 255, 200, 1),
    const Color.fromRGBO(73, 255, 200, 1)
  ];

  @override
  @override
  void initState() {
    _startCountDown();
    //Test State
    //Testend
    canAnswer = true;
    gameover = false;
    index = 0;
    richtigeAntworten = 0;
    retriveResult = false;
    alldone = false;
    //Reset all < Ka warum es dann workt WIP
    // Create an instance of the GameFinish class
    final refreshMainpageInstance =
        Provider.of<GameFinish>(context, listen: false);
    refreshMainpageInstance.addListener(() {
      falldone();
      print("Game DONE");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    Globals objglobals = Globals();

    return Scaffold(
        body: Container(
      width: maxWidth,
      height: maxHeight,
      color: objglobals.fourthColor,
      child: !gameover
          ? Stack(
              children: [
                //Own Char
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      maxWidth * 0.065, maxHeight * 0.07, 0, 0),
                  child: SizedBox(
                    width: maxWidth * 0.35,
                    height: maxHeight * 0.165,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: maxWidth,
                          height: maxHeight,
                          child: Image.asset(
                            context.watch<BGPath>().bgPath,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Stack(
                          children: [
                            SizedBox(
                              width: maxWidth,
                              height: maxHeight,
                              child: Image.asset(
                                context.watch<BGPath>().bgPath,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(
                              width: maxWidth * 0.35,
                              height: maxHeight * 0.14,
                              child: Visibility(
                                visible:
                                    context.watch<ModelPath>().modelPath != "",
                                child: ModelViewer(
                                  src: context.watch<ModelPath>().modelPath,
                                  alt: 'My 3D Model',
                                  ar: false, // Enable AR mode
                                  cameraControls:
                                      false, // Enable camera controls
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: maxHeight * 0.135),
                              child: Container(
                                color: objglobals.secondColor,
                                child: SizedBox(
                                  width: maxWidth * 0.35,
                                  height: maxHeight * 0.03,
                                  child: AutoSizeText(
                                    context.watch<PlayerName>().playerName,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.getFont(
                                      'Roboto', // Replace with your desired Google Font
                                      textStyle: const TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                //Enemy Char
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      maxWidth * 0.585, maxHeight * 0.07, 0, 0),
                  child: SizedBox(
                    width: maxWidth * 0.35,
                    height: maxHeight * 0.165,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: maxWidth,
                          height: maxHeight,
                          child: Image.asset(
                            context.watch<BGPathEnemy>().bgPath,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: maxWidth * 0.35,
                          height: maxHeight * 0.14,
                          child: ModelViewer(
                            src: context.watch<ModelPathEnemy>().modelPath,
                            alt: 'My 3D Model',
                            ar: false, // Enable AR mode
                            cameraControls: false, // Enable camera controls
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: maxHeight * 0.135),
                          child: Container(
                            color: objglobals.secondColor,
                            child: SizedBox(
                              width: maxWidth * 0.35,
                              height: maxHeight * 0.03,
                              child: AutoSizeText(
                                context.watch<enemyName>().nameEnemey,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.getFont(
                                  'Roboto', // Replace with your desired Google Font
                                  textStyle: const TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                //Fragen Box
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      maxWidth * 0.065, maxHeight * 0.25, maxWidth * 0.065, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: objglobals.mainColor,
                      border: Border.all(
                        width: maxHeight *
                            0.005, // adjust border thickness as desired
                        color: Colors.black, // choose border color
                        style: BorderStyle.solid,
                        // choose border style
                      ),
                    ),
                    width: double.maxFinite,
                    height: maxHeight * 0.2,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            maxWidth * 0.04, 0, maxWidth * 0.04, 0),
                        child: AutoSizeText(
                          widget.CFragenList![index].Frage,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont(
                            'Roboto', // Replace with your desired Google Font
                            textStyle: const TextStyle(
                                height: 0,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //Timer
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      maxWidth * 0.73, maxHeight * 0.2585, 0, 0),
                  child: SizedBox(
                    width: maxWidth * 0.18,
                    height: maxHeight * 0.03,
                    child: AutoSizeText(
                      timeLeft.toString(),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.getFont(
                        'Roboto', // Replace with your desired Google Font
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),

                //Karten Index
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      maxWidth * 0.73, maxHeight * 0.417, 0, 0),
                  child: SizedBox(
                    width: maxWidth * 0.18,
                    height: maxHeight * 0.03,
                    child: AutoSizeText(
                      "${index + 1}/4",
                      textAlign: TextAlign.right,
                      style: GoogleFonts.getFont(
                        'Roboto', // Replace with your desired Google Font
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                //Antwort1
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    maxWidth * 0.065,
                    maxHeight * 0.48,
                    maxWidth * 0.065,
                    0,
                  ),
                  child: GestureDetector(
                    onTap: () =>
                        proceedAnswer(widget.CFragenList![index].Antwort1, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors[0],
                        border: Border.all(
                          width: maxHeight *
                              0.0025, // adjust border thickness as desired
                          color: Colors.black, // choose border color
                          style: BorderStyle.solid,
                          // choose border style
                        ),
                      ),
                      width: double.maxFinite,
                      height: maxHeight * 0.1,
                      child: Center(
                        child: AutoSizeText(
                          widget.CFragenList![index].Antwort1,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont(
                            'Roboto', // Replace with your desired Google Font
                            textStyle: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //Antwort2
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    maxWidth * 0.065,
                    maxHeight * 0.60,
                    maxWidth * 0.065,
                    0,
                  ),
                  child: GestureDetector(
                    onTap: () =>
                        proceedAnswer(widget.CFragenList![index].Antwort2, 1),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors[1],
                        border: Border.all(
                          width: maxHeight *
                              0.0025, // adjust border thickness as desired
                          color: Colors.black, // choose border color
                          style: BorderStyle.solid,
                          // choose border style
                        ),
                      ),
                      width: double.maxFinite,
                      height: maxHeight * 0.1,
                      child: Center(
                        child: AutoSizeText(
                          widget.CFragenList![index].Antwort2,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont(
                            'Roboto', // Replace with your desired Google Font
                            textStyle: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //Antwort3
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    maxWidth * 0.065,
                    maxHeight * 0.72,
                    maxWidth * 0.065,
                    0,
                  ),
                  child: GestureDetector(
                    onTap: () =>
                        proceedAnswer(widget.CFragenList![index].Antwort3, 2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors[2],
                        border: Border.all(
                          width: maxHeight *
                              0.0025, // adjust border thickness as desired
                          color: Colors.black, // choose border color
                          style: BorderStyle.solid,
                          // choose border style
                        ),
                      ),
                      width: double.maxFinite,
                      height: maxHeight * 0.1,
                      child: Center(
                        child: AutoSizeText(
                          widget.CFragenList![index].Antwort3,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont(
                            'Roboto', // Replace with your desired Google Font
                            textStyle: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //Antwort4
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    maxWidth * 0.065,
                    maxHeight * 0.84,
                    maxWidth * 0.065,
                    0,
                  ),
                  child: GestureDetector(
                    onTap: () =>
                        proceedAnswer(widget.CFragenList![index].Antwort4, 3),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors[3],
                        border: Border.all(
                          width: maxHeight *
                              0.0025, // adjust border thickness as desired
                          color: Colors.black, // choose border color
                          style: BorderStyle.solid,
                          // choose border style
                        ),
                      ),
                      width: double.maxFinite,
                      height: maxHeight * 0.1,
                      child: Center(
                        child: AutoSizeText(
                          widget.CFragenList![index].Antwort4,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont(
                            'Roboto', // Replace with your desired Google Font
                            textStyle: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(children: [
              const SizedBox(
                height: 200,
              ),
              Visibility(
                visible: context.watch<GameFinish>().ergebnis.isEmpty,
                child: Container(
                  width: maxWidth,
                  height: maxHeight * 0.1,
                  color: Colors.amber,
                  child: const Center(
                    child: Text(
                      "Warten auf den  Gegner",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 41, 11, 234),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: context.watch<GameFinish>().ergebnis.isEmpty,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      maxWidth * 0.15, maxHeight * 0.02, maxWidth * 0.15, 0),
                  child: SizedBox(
                    height: maxHeight * 0.08,
                    width: double.maxFinite,
                    child: Lottie.asset('lib/images/97443-loading-gray.json'),
                  ),
                ),
              ),
              Visibility(
                visible: context.watch<GameFinish>().ergebnis.isNotEmpty,
                child: Container(
                  width: maxWidth,
                  height: maxHeight * 0.1,
                  color: Colors.amber,
                  child: Center(
                    child: Text(
                      context.watch<GameFinish>().ergebnis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 41, 11, 234),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: context.watch<GameFinish>().ergebnis.isNotEmpty,
                child: GestureDetector(
                  onTap: () {
                    context.read<GameFinish>().getErgebnis("");
                    Navigator.pop(context);
                    fetchMetadata(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: maxHeight * 0.1),
                    child: Container(
                      decoration: BoxDecoration(
                        color: objglobals.secondColor,
                        border: Border.all(
                          width: maxHeight *
                              0.004, // adjust border thickness as desired
                          color: Colors.black, // choose border color
                          style: BorderStyle.solid,
                          // choose border style
                        ),
                      ),
                      width: maxWidth * 0.5,
                      height: maxHeight * 0.1,
                      child: Center(
                        child: Text(
                          "Weiter",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont(
                            'Roboto', // Replace with your desired Google Font
                            textStyle: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ]),
    ));
  }
}

void updateResult() {}

class GameFinish extends ChangeNotifier {
  String ergebnis = "";
  bool state = false;

  void getErgebnis(getErgebnis) {
    ergebnis = getErgebnis;
  }

  void setTrue() {
    state = true;
    notifyListeners();
  }
}
