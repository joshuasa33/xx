import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:testre/INGAME/ingame.dart';
import 'package:testre/INGAME/reskin.dart';

void getDataStartGame(
    BuildContext context, String jsonData, String getgameguid) {
  List<dynamic> data = jsonDecode(jsonData);
  List<CFragen> fragenList =
      List<CFragen>.from(data.map((item) => CFragen.fromJson(item)));

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ReSkin(
                CFragenList: fragenList,
                gameguid: getgameguid,
              )));
}

class CFragen {
  String Frage;
  String Antwort1;
  String Antwort2;
  String Antwort3;
  String Antwort4;
  String RichtigeAntwort;
  String Laendercode;
  String Kategorie;

  CFragen({
    required this.Frage,
    required this.Antwort1,
    required this.Antwort2,
    required this.Antwort3,
    required this.Antwort4,
    required this.RichtigeAntwort,
    required this.Laendercode,
    required this.Kategorie,
  });

  factory CFragen.fromJson(Map<String, dynamic> json) {
    return CFragen(
        Frage: json['Frage'],
        Antwort1: json['Antwort1'],
        Antwort2: json['Antwort2'],
        Antwort3: json['Antwort3'],
        Antwort4: json['Antwort4'],
        RichtigeAntwort: json['RichtigeAntwort'],
        Laendercode: json['laendercode'],
        Kategorie: json['Kategorie']);
  }

  @override
  String toString() {
    return 'Frage: $Frage\nAntwort1: $Antwort1\nAntwort2: $Antwort2\nAntwort3: $Antwort3\nAntwort4: $Antwort4\nRichtigeAntwort: $RichtigeAntwort\nLaendercode: $Laendercode\n';
  }
}
