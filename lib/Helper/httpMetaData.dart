// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:testre/CharPage/fileChar.dart';
import 'package:testre/GamePage/fightPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ShopPage/pushCoins.dart';
import 'globals.dart';

Future<void> fetchMetadata(BuildContext context) async {
  Prefs objprefs = await getPrefs();
  String playerguid = objprefs.playerguid;
  final url = Uri.https(
    'europe-west3-dev-exchanger-383804.cloudfunctions.net',
    '/resolveMetaData',
    {'playerguid': playerguid},
  );
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Metadata retrieved successfully
      final metadata = json.decode(response.body);
      final player = Player.fromJson(metadata);
      //print(player.playername);
      //print(player.elo);
      context.read<PlayerElo>().updatePlayer(player.elo.toString());
      context.read<PlayerName>().updatePlayer(player.playername);

      context.read<PlayerMoney>().updatePlayer(player.money.split(".")[0]);
    } else {
      // Error retrieving metadata
      print('Error retrieving metadata: ${response.statusCode}');
      // Handle the error
    }
  } catch (error) {
    // Error retrieving metadata
    print('Error retrieving metadata: $error');
    // Handle the error
  }

  //Check if Coins needs to be Updated
  try {
    int getcoins = await saveCoins(0);
    if (getcoins != 0) {
      String playerguid = "";
      const constguid = "playerguid";
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(constguid)) {
        playerguid = prefs.getString(constguid)!;
      }
    }
    await pushCoins(playerguid, getcoins);
  } catch (e) {
    print("Error MetaData+e");
  }
}

class Player {
  String playername;
  String playerguid;
  String countrycode;
  String operatingsystem;
  int elo;
  String money;

  Player(
      {required this.playername,
      required this.playerguid,
      required this.countrycode,
      required this.operatingsystem,
      required this.elo,
      required this.money});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      playername: json['playername'],
      playerguid: json['playerguid'],
      countrycode: json['countrycode'],
      operatingsystem: json['operatingsystem'],
      elo: json['elo'],
      money: json['money'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['playername'] = this.playername;
    data['playerguid'] = this.playerguid;
    data['countrycode'] = this.countrycode;
    data['operatingsystem'] = this.operatingsystem;
    data['elo'] = this.elo;
    data['money'] = this.money;
    return data;
  }
}

Future<void> getCharData(BuildContext context) async {
  MyChars obj = await decodeItems();
  context.read<ModelPath>().changePath(obj.currentChar);
  context.read<BGPath>().changePath(obj.currentBackground);
}
