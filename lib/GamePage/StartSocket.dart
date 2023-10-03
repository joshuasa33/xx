import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testre/GamePage/fightPage.dart';
import 'package:testre/GamePage/initfragen.dart';
import 'package:web_socket_channel/io.dart';

import '../INGAME/reskin.dart';

IOWebSocketChannel? _channel;

void connectToWebSocket(String playerGuid, String elo, BuildContext context,
    String charPath, String bgPath, String name,
    {bool close = false}) {
  context.read<GameFinish>().getErgebnis("");

  try {
    if (context.read<SearchSocket>().state || close == true) {
      if (_channel != null && _channel!.closeCode == null) {
        // If there is an active connection, close it before connecting again
        _channel!.sink.close();
        context.read<SearchSocket>().setFalse();
        return;
      }
    }

    if (_channel != null && _channel!.closeCode == null) {
      // If there is an active connection, close it before connecting again
      _channel!.sink.close();
      context.read<SearchSocket>().setFalse();
    }

    String countrycode = "DE";
    final url =
        'ws://34.107.42.94:8090/?playerguid=$playerGuid&elo=$elo&countrycode=$countrycode&action=game&charpath=$charPath&bgpath=$bgPath&name=$name';

    _channel = IOWebSocketChannel.connect(url);
    context.read<SearchSocket>().setTrue();

    print('WebSocket Connected');

    // Handle incoming messages
    _channel!.stream.listen((message) {
      var gameIdentfier = "!StartGame!";
      if (message.toString().contains(gameIdentfier)) {
        print('Ready To StartGame');
        String rightString = message.toString().split(gameIdentfier)[1];
        String gameguid = message.toString().split(gameIdentfier)[0];
        String charEnemy = message.toString().split(gameIdentfier)[2];
        String bgEnemy = message.toString().split(gameIdentfier)[3];
        String nameEnemy = message.toString().split(gameIdentfier)[4];
        print("$bgEnemy $charEnemy" " $nameEnemy");
        _channel!.sink.close();
        context.read<SearchSocket>().setFalse();
        context.read<enemyName>().updatePlayer(nameEnemy);

        if (chars.contains(bgEnemy)) {
          context.read<BGPathEnemy>().changePath(bgPath);
        }
        if (chars.contains(charEnemy)) {
          context.read<ModelPathEnemy>().changePath(charEnemy);
        }
        getDataStartGame(context, rightString, gameguid);
      }
    }, onDone: () {
      print("Done");
    });

    // Send a message to the server
    const message = 'Hello from Flutter!';
    _channel!.sink.add(message);
  } finally {}
}

List<String> BGs = [
  "Backgrounds/BG01.jpg",
  "Backgrounds/BG02.jpg",
  "Backgrounds/BG03.jpg",
  "Backgrounds/BG04.jpg",
  "Backgrounds/BG05.jpg",
  "Backgrounds/BG06.jpg",
  "Backgrounds/BG00.jpg"
];
List<String> chars = [
  "3DModels/Pilzi.glb",
  "3DModels/Assasin.glb",
  "3DModels/BlueDuo.glb",
  "3DModels/ColorDuo.glb",
  "3DModels/DeepSea.glb",
  "3DModels/FnFighter.glb",
  "3DModels/thefuture.glb"
];
