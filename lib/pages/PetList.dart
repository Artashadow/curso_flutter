import 'package:demo/models/Pet.dart';
import 'package:demo/utils/ImageUtils.dart';
import 'package:flutter/material.dart';
import '../routes/DetailPetPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/ProgressIndicatorUtils.dart';

class PetList extends StatefulWidget {
  PetList({super.key});
  PetListState petListState = PetListState();

  @override
  createState() => petListState;
}

class PetListState extends State<PetList> {
  List<Pet> pets = List.empty(growable: true);

  Future<List<Pet>> getPets() async {
    const String endpointPets =
        'https://mobile-courses-api-5a809b95fc81.herokuapp.com/api/pets';
    final response = await http.get(Uri.parse(endpointPets));
    if (response.statusCode == 200) {
      List<dynamic> result = json.decode(response.body);
      pets = result.map((model) => Pet.fromJson(model)).toList();
      return pets;
    } else {
      throw Exception('Fallo al cargar información del servidor');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Pet>>(
        future: getPets(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: buildItemsForListView,
              itemCount: snapshot.data?.length ?? 0,
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return progressIndicator('Cargando...');
        },
      ),
    );
  }

  Widget buildItemsForListView(BuildContext context, int index) {
    return Card(
      margin: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Container(child: imageWidgetWithSize(pets[index].image, 150, 150)),
          Container(
            child: Text(pets[index].name, style: const TextStyle(fontSize: 23)),
          ),
          iconButton('Ver amigo', () => {goToDetail(context, pets[index].id)}),
        ],
      ),
    );
  }

  Widget iconButton(String text, Function pressed) {
    return TextButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.remove_red_eye),
          const SizedBox(width: 5),
          Text(text),
        ],
      ),
      onPressed: () => {pressed()},
    );
  }

  void goToDetail(BuildContext context, int petId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPetPage(petId)),
    );
  }

  Future<void> refresh() async {
    await getPets();
    setState(() {});
  }
}
