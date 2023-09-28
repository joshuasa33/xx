import 'dart:convert';
import 'package:http/http.dart' as http;

final cloudFunctionUrl =
    'https://europe-west3-dev-exchanger-383804.cloudfunctions.net/PurchaseItem';

//Http request createUser wenn möglich sonst return message;
Future<int> callBuyItem(
  String assetItem,
  String playerguid,
) async {
  final data = {
    'sendplayerguid': playerguid,
    'sendshopitem': assetItem,
  };

  final response = await http.post(
    Uri.parse(cloudFunctionUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  print('Statuscode: ${response.statusCode}');
  print(response.body);
  return response.statusCode;
}
