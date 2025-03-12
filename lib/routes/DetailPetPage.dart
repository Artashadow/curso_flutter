import 'package:demo/utils/ImageUtils.dart';
import 'package:demo/utils/ProgressIndicatorUtils.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Pet.dart';

class DetailPetPage extends StatelessWidget {
  const DetailPetPage(this.idPet, {super.key});
  final int idPet;

  Future<Pet> getPet() async {
    final String id = idPet.toString();
    final String endpointPets =
        'https://mobile-courses-api-5a809b95fc81.herokuapp.com/api/pets/$id';
    final response = await http.get(Uri.parse(endpointPets));
    if (response.statusCode == 200) {
      return Pet.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar la mascota');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle amigo')),
      body: FutureBuilder<Pet>(
        future: getPet(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Card(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        imageWidgetWithSize(
                          snapshot.data?.image ?? '',
                          250,
                          250,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      snapshot.data?.name ?? '',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      snapshot.data?.description ?? '',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return progressIndicator('Cargando...');
        },
      ),
    );
  }
}
