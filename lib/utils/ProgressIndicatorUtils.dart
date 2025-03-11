import 'package:flutter/material.dart';

Widget progressIndicator(String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(padding: const EdgeInsets.all(20.0), child: Text(message)),
        const CircularProgressIndicator(),
      ],
    ),
  );
}
