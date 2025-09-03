import 'dart:io';

import 'package:logger/logger.dart';

File file = File("abrakadabra.txt");

var myLogger = Logger(
  printer: PrettyPrinter(
    //methodCount: 0,
    //errorMethodCount: 5,
    //lineLength: 50,
    colors: false,
    printEmojis: false,
    dateTimeFormat: DateTimeFormat.dateAndTime,
  ),
  output: FileOutput(file: file),
  filter: MyFilter(),
);

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
