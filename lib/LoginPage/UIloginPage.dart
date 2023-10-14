import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Helper/globals.dart';
import 'loginHTTP.dart';

class Login extends StatefulWidget {
  const Login({
    super.key,
  });

  @override
  State<Login> createState() => _LoginState();
}

bool ispressable = true;

class _LoginState extends State<Login> {
  @override
  @override
  void initState() {
    super.initState();
  }

  final myController = TextEditingController();
  String errorText = "";
  @override
  Widget build(BuildContext context) {
    Globals objglobals = Globals();
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: objglobals.mainColor,
        child: Column(
          children: <Widget>[
            //Header
            Padding(
              padding: EdgeInsets.fromLTRB(0, maxHeight * 0.08, 0, 0),
              child: SizedBox(
                width: maxWidth,
                child: AutoSizeText(
                  "Quiz Pvp",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 100,
                      fontFamily: 'Cyberthic',
                      height: maxHeight * 0.00125),
                ),
              ),
            ),
            //Error Text
            Padding(
              padding: EdgeInsets.fromLTRB(
                  maxWidth * 0.15, maxHeight * 0.075, maxWidth * 0.15, 0),
              child: SizedBox(
                width: maxWidth,
                height: maxHeight * 0.025,
                child: AutoSizeText(
                  errorText,
                  style: TextStyle(fontSize: 35, color: objglobals.fourthColor),
                ),
              ),
            ),
            //Textfield
            Padding(
              padding:
                  EdgeInsets.fromLTRB(maxWidth * 0.15, 0, maxWidth * 0.15, 0),
              child: Container(
                width: maxWidth,
                height: maxHeight * 0.07,
                decoration: BoxDecoration(
                  border: Border.all(
                    width:
                        maxHeight * 0.005, // adjust border thickness as desired
                    color: Colors.black, // choose border color
                    style: BorderStyle.solid,
                    // choose border style
                  ),
                ),
                child: Padding(
                    padding: EdgeInsets.only(left: maxWidth * 0.05),
                    child: TextField(
                      maxLines: 1,
                      controller: myController,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "Dein Name"),
                      style: TextStyle(
                        fontSize: maxWidth * 0.07, // Change font size here
                        color: Colors.black, // Change text color here
                      ),
                    )),
              ),
            ),
//ELEVATED BUTTON
            Padding(
              padding:
                  EdgeInsets.fromLTRB(maxWidth * 0.15, 0.0, maxWidth * 0.15, 0),
              child: SizedBox(
                width: maxWidth,
                height: maxHeight * 0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(maxHeight * 0.00)),
                    backgroundColor: objglobals.fourthColor,
                  ),
                  onPressed: ispressable
                      ? () async {
                          if (myController.text.length > 14) {
                            setState(() {
                              errorText = ("Maximal 14 Zeichen");
                            });
                            return;
                          }
                          // Obtain shared preferences.
                          final List<Locale> systemLocales =
                              WidgetsBinding.instance.window.locales;

                          if (myController.text.length > 2) {
                            //init Variables
                            String playername = myController.text;
                            String playerguid = await FlutterUdid.udid;
                            String? countrycode =
                                systemLocales.first.countryCode;
                            String operatingSystem = Platform.operatingSystem;
                            countrycode ??= "Default";
                            //Check if connection =true
                            var connectivityResult =
                                await (Connectivity().checkConnectivity());

                            if (connectivityResult == ConnectivityResult.none) {
                              setState(() {
                                errorText = "Keine internet Verbindung";
                              });
                            } else {
                              setState(() {
                                ispressable = false;
                              });
                              int statuscode = await callCloudFunction(
                                  playername,
                                  playerguid,
                                  countrycode,
                                  operatingSystem);
                              setState(() {
                                ispressable = true;
                              });

                              if (statuscode == 201 || statuscode == 409) {
                                //Player Added 201 - Player gibt es 409
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString("name", playername);
                                prefs.setString("playerguid", playerguid);
                                print("Navigate");
                                Navigator.pushNamed(context, "/gamePage");
                              }
                            }
                          } else {
                            setState(() {
                              errorText = "Name zu kurz";
                            });
                          }
                        }
                      : null,
                  child: AutoSizeText(
                    "Register",
                    style: GoogleFonts.getFont(
                      'Orbitron', // Replace with your desired Google Font
                      textStyle: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
//

            SizedBox(
              height: maxHeight * 0.03,
            ),
            Expanded(
              child: SizedBox(
                width: maxWidth,
                height: maxHeight * 0.4,
                child: const ModelViewer(
                  src: "3DModels/bike.glb",
                  alt: 'My 3D Model',
                  ar: false, // Enable AR mode
                  autoRotate: true, // Enable auto-rotation
                  cameraControls: false, // Enable camera controls
                  rotationPerSecond: ("1rad"),
                ),
              ),
            )

////
            //3D Model
            /*
            Padding(
              padding: EdgeInsets.fromLTRB(
                  maxWidth * 0.3, maxHeight * 0.3, 0, maxHeight * 0.1),
              child: ModelViewer(
                src: "3DModels/stylized_character.glb",
                alt: 'My 3D Model',
                ar: false, // Enable AR mode
                autoRotate: false, // Enable auto-rotation
                cameraControls: false, // Enable camera controls
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}

class TEST extends StatefulWidget {
  const TEST({super.key});

  @override
  State<TEST> createState() => _TESTState();
}

class _TESTState extends State<TEST> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
