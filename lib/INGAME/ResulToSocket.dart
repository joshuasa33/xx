import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testre/INGAME/reskin.dart';
import 'package:web_socket_channel/io.dart';

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
    debugPrint('WebSocket Connected');

    _channel?.stream.listen((message) {
      debugPrint('Ready To Proceed Result$message');
      _channel!.sink.close();
      if (message.toString().contains(gameOverIdentefier)) {
        context.read<GameFinish>().setTrue();
        debugPrint(message.toString());
        if (message.toString().contains(win)) {
          debugPrint("win");
          context.read<GameFinish>().getErgebnis("Gewonnen");
          return;
        }
        if (message.toString().contains(lose)) {
          context.read<GameFinish>().getErgebnis("Verloren");
          return debugPrint("lose");
        }
        if (message.toString().contains(draw)) {
          context.read<GameFinish>().getErgebnis("Unentschieden");
          debugPrint("draw +/n " * 7);
          return;
        }
        if (lasttry == true) {
          context.read<GameFinish>().getErgebnis("Netzwerkfehler");
        }
      }
      debugPrint("close connection$message");
    }, onDone: () {
      debugPrint("Done");
    });
  } catch (e) {
    debugPrint("Error resultToWS$e");
  } finally {}
}
