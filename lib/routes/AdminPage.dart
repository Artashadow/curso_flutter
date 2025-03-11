import 'package:demo/models/Pet.dart';
import 'package:demo/routes/AddPetPage.dart';
import 'package:demo/routes/EditPage.dart';
import 'package:demo/utils/ImageUtils.dart';
import 'package:demo/utils/ProgressIndicatorUtils.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  List<Pet> pets = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    getPets();
  }

  Future<void> getPets() async {
    const String endpointPets =
        'https://mobile-courses-api-5a809b95fc81.herokuapp.com/api/pets';
    final response = await http.get(Uri.parse(endpointPets));
    if (response.statusCode == 200) {
      List<dynamic> result = json.decode(response.body);
      setState(() {
        pets = result.map((model) => Pet.fromJson(model)).toList();
      });
    } else {
      throw Exception('Fallo al cargar información del servidor');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: tabs(context),
        body: TabBarView(children: [favoritosContent(context), todos(context)]),
        floatingActionButton: circularButton(context),
      ),
    );
  }

  PreferredSizeWidget tabs(BuildContext context) {
    return AppBar(
      title: const Text('Más Petamigos'),
      bottom: const TabBar(tabs: [Tab(text: 'Favoritos'), Tab(text: 'Todos')]),
    );
  }

  Widget favoritosContent(BuildContext context) {
    return ListView(
      children: [
        Divider(height: 15.0),
        Card(margin: EdgeInsets.all(5), child: itemRow(context)),
      ],
    );
  }

  Widget todos(BuildContext context) {
    if (pets.isEmpty) {
      return progressIndicator('');
    } else {
      return ListView.builder(itemCount: pets.length, itemBuilder: petsBuilder);
    }
  }

  Widget petsBuilder(BuildContext context, int pos) {
    return Card(
      margin: const EdgeInsets.all(5.0),
      child: itemRow2(context, pos),
    );
  }

  Widget circularButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      backgroundColor: Colors.blue,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddPetPage()),
        );
      },
    );
  }

  void goToEditPage(BuildContext context, int idPet) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPage()),
    );
  }

  Widget itemRow(BuildContext context) {
    return ListTile(
      title: const Text('Amigo'),
      subtitle: const Text('Edad: 0 años'),
      leading: Image.asset('images/logo.jpeg'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              goToEditPage(context, 0);
            },
          ),
          IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
        ],
      ),
    );
  }

  Widget itemRow2(BuildContext context, int pos) {
    return ListTile(
      title: Text(pets[pos].name),
      subtitle: Text('Edad: ${pets[pos].age} años'),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: imageWidgetWithSize(pets[pos].image, 50.0, 50.0),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              goToEditPage(context, pets[pos].id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteAlert(context, pos, pets[pos].id);
            },
          ),
        ],
      ),
    );
  }

  Future deleteAlert(BuildContext context, int position, int id) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('Esta acción no puede deshacerse'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                deletePet(context, position, id);
              },
            ),
          ],
        );
      },
    );
  }

  void deletePet(BuildContext context, int position, int id) async {
    final String endpointDeletePet =
        'https://android-course-api.herokuapp.com/api/pets/$id';
    final response = await http.delete(Uri.parse(endpointDeletePet));
    if (response.statusCode == 200) {
      setState(() {
        pets.removeAt(position);
      });
    } else {
      throw Exception('Fallo al cargar información del servidor');
    }
    Navigator.of(context).pop();
  }
}
