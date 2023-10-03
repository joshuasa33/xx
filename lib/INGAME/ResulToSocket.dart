import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testre/GamePage/initfragen.dart';
import 'package:testre/INGAME/reskin.dart';
import 'package:web_socket_channel/io.dart';

import '../GamePage/GamePage.dart';

IOWebSocketChannel? _channel;

void resultToWebsocket(String playerGuid, String result, String gameguid,
    BuildContext context, String doneState,
    {bool? lasttry = false}) {
  const String gameOverIdentefier = "GameOverBoy";
  const draw = "Draw";
  const String win = "win";
  const String lose = "lose";

  try {
    if (_channel != null && _channel!.closeCode == null) {
      // If there is an active connection, close it before connecting again
      _channel!.sink.close();
    }
    final url =
        'ws://34.107.42.94:8090/?playerguid=$playerGuid&resultGame=$result&action=result&gameguid=$gameguid&done=$doneState';

    _channel = IOWebSocketChannel.connect(url);
    print('WebSocket Connected');

    _channel?.stream.listen((message) {
      print('Ready To Proceed Result$message');
      _channel!.sink.close();
      if (message.toString().contains(gameOverIdentefier)) {
        context.read<GameFinish>().setTrue();
        print(message.toString());
        if (message.toString().contains(win)) {
          print("win");
          context.read<GameFinish>().getErgebnis("Gewonnen");
          return;
        }
        if (message.toString().contains(lose)) {
          context.read<GameFinish>().getErgebnis("Verloren");
          return print("lose");
        }
        if (message.toString().contains(draw)) {
          context.read<GameFinish>().getErgebnis("Unentschieden");
          print("draw +/n " * 7);
          return;
        }
        if (lasttry == true) {
          context.read<GameFinish>().getErgebnis("Netzwerkfehler");
        }
      }
      print("close connection$message");
    }, onDone: () {
      print("Done");
    });
  } catch (e) {
    print("Error resultToWS$e");
  } finally {}
}
