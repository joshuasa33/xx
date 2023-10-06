import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Helper/globals.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    Globals objglobals = Globals();
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Container(
        color: objglobals.mainColor,
        child: Column(children: [
          //Top Header
          Padding(
            padding: EdgeInsets.fromLTRB(
                maxWidth * 0.0, maxHeight * 0.078, maxWidth * 0.00, 0),
            child: Container(
              decoration: BoxDecoration(
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
              child: Container(
                color: objglobals.secondColor,
                height: maxHeight,
                width: maxWidth * 0.6,
                child: AutoSizeText(
                  "Einstellungen",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    'Orbitron', // Replace with your desired Google Font
                    textStyle: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),

          //  KONTAKT Header
          Padding(
            padding: EdgeInsets.fromLTRB(
                maxWidth * 0.3, maxHeight * 0.02, maxWidth * 0.30, 0),
            child: SizedBox(
              height: maxHeight * 0.05,
              width: double.maxFinite,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: maxHeight * 0.003,
                      style: BorderStyle.solid,
                    ),
                    bottom: BorderSide(
                      width: maxHeight * 0.003,
                      color: Colors.black,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                height: maxHeight,
                width: maxWidth * 0.6,
                child: AutoSizeText(
                  "Kontakt",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    'Orbitron', // Replace with your desired Google Font
                    textStyle: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),

          // Contact Text
          Padding(
            padding: EdgeInsets.fromLTRB(
                maxWidth * 0.15, 0.015 * maxHeight, maxWidth * 0.15, 0),
            child: SizedBox(
              height: maxHeight * 0.08,
              width: maxWidth,
              child: const AutoSizeText(
                "Fragen, Feedback oder Sonstiges gerne an \njoshuaboll@hotmail.com",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),

          //Line
          Padding(
            padding: EdgeInsets.only(top: maxHeight * 0.02),
            child: Container(
              width: maxWidth,
              height: maxHeight * 0.01,
              color: objglobals.thirdColor,
            ),
          ),
          //

          //ELEVATED BUTTON
          Padding(
            padding: EdgeInsets.fromLTRB(
                maxWidth * 0.15, 0.015 * maxHeight, maxWidth * 0.15, 0),
            child: Container(
              width: maxWidth,
              decoration: BoxDecoration(
                border: Border.all(
                  width: maxHeight * 0.00, // adjust border thickness as desired
                  color: Colors.black, // choose border color
                  style: BorderStyle.solid,
                  // choose border style
                ),
              ),
              height: maxHeight * 0.07,
              child: GestureDetector(
                onTap: () {
                  final Uri toLaunch = Uri(
                      scheme: 'https',
                      host: 'jandspice.blogspot.com',
                      path: '/2023/08/datenschutzerklarung-quizpvp.html');
                  print(toLaunch.toString());
                  launchUrl(toLaunch);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: objglobals.secondColor,
                    border: Border.all(
                      width: maxHeight *
                          0.005, // adjust border thickness as desired
                      color: Colors.black, // choose border color
                      style: BorderStyle.solid,
                      // choose border style
                    ),
                  ),
                  child: Center(
                    child: AutoSizeText(
                      ">>>Datenschutz<<<",
                      style: GoogleFonts.getFont(
                        'Orbitron', // Replace with your desired Google Font
                        textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: objglobals.thirdColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          //AGB
          //ELEVATED BUTTON
          Padding(
            padding: EdgeInsets.fromLTRB(
                maxWidth * 0.15, 0.015 * maxHeight, maxWidth * 0.15, 0),
            child: Container(
              width: maxWidth,
              decoration: BoxDecoration(
                border: Border.all(
                  width: maxHeight * 0.00, // adjust border thickness as desired
                  color: Colors.black, // choose border color
                  style: BorderStyle.solid,
                  // choose border style
                ),
              ),
              height: maxHeight * 0.07,
              child: GestureDetector(
                onTap: () {
                  final Uri toLaunch = Uri(
                      scheme: 'https',
                      host: 'jandspice.blogspot.com',
                      path: '/2023/08/agb-quizpvp.html');
                  print(toLaunch.toString());
                  launchUrl(toLaunch);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: objglobals.secondColor,
                    border: Border.all(
                      width: maxHeight *
                          0.005, // adjust border thickness as desired
                      color: Colors.black, // choose border color
                      style: BorderStyle.solid,
                      // choose border style
                    ),
                  ),
                  child: Center(
                    child: AutoSizeText(
                      ">>>>>>>>>AGB<<<<<<<<<",
                      style: GoogleFonts.getFont(
                        'Orbitron', // Replace with your desired Google Font
                        textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: objglobals.thirdColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}
