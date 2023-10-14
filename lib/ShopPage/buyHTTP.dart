import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const cloudFunctionUrl =
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

  debugPrint('Statuscode: ${response.statusCode}');
  debugPrint(response.body);
  return response.statusCode;
}
