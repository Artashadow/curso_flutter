import 'package:demo/pages/PetList.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final PetList petList = PetList();

  @override
  Widget build(BuildContext context) {
    return petList;
  }
}
