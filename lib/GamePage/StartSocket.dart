import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testre/GamePage/fightPage.dart';
import 'package:testre/GamePage/initfragen.dart';
import 'package:web_socket_channel/io.dart';

import '../INGAME/reskin.dart';

IOWebSocketChannel? _channel;

void connectToWebSocket(String playerGuid, String elo, BuildContext context,
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
        'ws://34.107.42.94:8090/?playerguid=$playerGuid&elo=$elo&countrycode=$countrycode&action=game';

    _channel = IOWebSocketChannel.connect(url);
    context.read<SearchSocket>().setTrue();

    print('WebSocket Connected');

    // Handle incoming messages
    _channel!.stream.listen((message) {
      var gameIdentfier = "!StartGame!";
      if (message.toString().contains(gameIdentfier)) {
        print('Ready To StartGame');
        //String rightString = message.toString().replaceAll(gameIdentfier, '');
        String rightString = message.toString().split(gameIdentfier)[1];
        String gameguid = message.toString().split(gameIdentfier)[0];
        getDataStartGame(context, rightString, gameguid);
        _channel!.sink.close();
        context.read<SearchSocket>().setFalse();
        print("false");
      }
    }, onDone: () {
      print("Done");
    });

    // Send a message to the server
    final message = 'Hello from Flutter!';
    _channel!.sink.add(message);
  } catch (e) {
  } finally {}
}
