import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pushCoins(String playerguid, int amount) async {
  try {
    final url = Uri.parse(
        'https://europe-west3-dev-exchanger-383804.cloudfunctions.net/UpdateCoins?playerguid=$playerguid&amount=$amount');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      print('Coins pushed successfully!');
      await resetCoins();
    } else {
      print('Coins push failed.');
    }
  } catch (e) {
    print("Error Pushcoins + Prob No connection:$e");
  }
}

Future<int> saveCoins(int amount) async {
  const String constCoins = "getCoins";
  int coins = 0;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(constCoins)) {
    coins = prefs.getInt(constCoins)!;
  }
  coins += amount;
  await prefs.setInt(constCoins, coins);
  return coins;
}

Future<void> resetCoins() async {
  const String constCoins = "getCoins";
  const int coins = 0;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(constCoins, coins);
}
