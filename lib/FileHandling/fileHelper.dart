import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

//Writedata aufrufen und file einspeichern
String filename = '';
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = "${await _localPath}/$filename";
  return File(path);
}

Future<File> writeData(String json, String filenamesent) async {
  filename = filenamesent;
  final file = await _localFile;
  return file.writeAsString(json);
}
//End write data

// Read JSONFILE

Future<String> retrieveData(String filenamesent) async {
  final directory = await getApplicationDocumentsDirectory();
  String path = "${directory.path}/$filenamesent";
  debugPrint(path);
  String jsonString = await File(path).readAsString();
  return jsonString;
}

Future<bool> fileExists(String pathsend) async {
  final directory = await getApplicationDocumentsDirectory();
  String path = "${directory.path}/$pathsend";
  bool state = await File(path).exists();
  //debugPrint(path);
  return state;
}

Future<void> deleteAllFiles() async {
  final directory = await getApplicationDocumentsDirectory();

  final files = directory.listSync(recursive: true);
  for (final file in files) {
    if (file is File) {
      await file.delete();
    }
  }
}
