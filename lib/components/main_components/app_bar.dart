import 'package:flutter/material.dart';

AppBar appBarWithAllTokens() {
  return AppBar(
    backgroundColor:
        Colors.indigoAccent, // Replace with your dynamic color logic
    title: Text('Продажи в ТМ', style: const TextStyle(fontSize: 18)),
    centerTitle: true,
    elevation: 15,
    toolbarHeight: 70,
    // actions: <Widget>[
    //   MyPopupMenuButton(userCreds: userCreds),
    //   const SizedBox(
    //     width: 25,
    //   )
    // ],
  );
}
