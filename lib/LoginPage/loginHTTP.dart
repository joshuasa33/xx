import 'dart:convert';
import 'package:http/http.dart' as http;

final cloudFunctionUrl =
    'https://us-central1-dev-exchanger-383804.cloudfunctions.net/CreateOrGetUserUnsec';

//Http request createUser wenn möglich sonst return message;
Future<int> callCloudFunction(
  String playername,
  String playerguid,
  String countrycode,
  String operatingsystem,
) async {
  final data = {
    'playername': playername,
    'playerguid': playerguid,
    'countrycode': countrycode,
    'operatingsystem': operatingsystem,
    'elo': 0,
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
