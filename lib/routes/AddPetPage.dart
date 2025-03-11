import 'dart:io';

import 'package:demo/models/StatusPet.dart';
import 'package:demo/models/TypePet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPetPage extends StatelessWidget {
  const AddPetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir Amigo')),
      body: const FormAddPet(),
    );
  }
}

class FormAddPet extends StatefulWidget {
  const FormAddPet({super.key});

  @override
  createState() => FormAddPetState();
}

class FormAddPetState extends State<FormAddPet> {
  List<TypePet> types = [];
  TypePet selectedType = TypePet(id: -1, name: 'Por favor escoge');
  StatusPet selectedStatus = StatusPet(id: 1, name: 'Abandonado');

  bool isRescued = false;
  File? imageFile;
  GlobalKey<FormState> formKey = GlobalKey();

  Future<void> getPetType() async {
    const String endpointTypePets =
        'https://mobile-courses-api-5a809b95fc81.herokuapp.com/api/pets/type_pet';
    final response = await http.get(Uri.parse(endpointTypePets));
    if (response.statusCode == 200) {
      List<dynamic> result = json.decode(response.body);
      setState(() {
        types = result.map((model) => TypePet.fromJson(model)).toList();
      });
    } else {
      throw Exception('Fallo al cargar información del servidor');
    }
  }

  @override
  void initState() {
    super.initState();
    getPetType();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.pets),
                  labelText: 'Nombre:',
                  hintText: 'Nombre',
                ),
                maxLength: 32,
                validator:
                    (value) =>
                        validateText(value!, 'Coloca un nombre para tu amigo'),
              ),
              TextFormField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  icon: Icon(Icons.book),
                  labelText: 'Descripción:',
                  hintText: 'Descripción',
                ),
                validator:
                    (value) => validateText(value!, 'Agrega una descripción'),
                maxLength: 312,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  icon: Icon(Icons.date_range),
                  labelText: 'Edad:',
                  hintText: 'Edad',
                ),
                validator:
                    (value) => validateAge(
                      value!,
                      'Coloca una edad aproximada para tu amigo',
                    ),
                maxLength: 2,
              ),
              Container(
                padding: const EdgeInsets.only(left: 5.0, top: 10.0),
                child: DropdownButton(
                  hint: Text(selectedType.name),
                  isExpanded: true,
                  items:
                      types
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value.name),
                            ),
                          )
                          .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedType = newValue as TypePet;
                    });
                  },
                ),
              ),
              SwitchListTile(
                title: const Text('Rescatado'),
                value: isRescued,
                onChanged: (value) {
                  setState(() {
                    isRescued = value;
                  });
                },
              ),
              imageChooser(),
              sendButton(() => {validateForm()}),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageDefault() {
    String hint = 'Seleccionar imagen';
    return Container(
      padding: const EdgeInsets.all(20.0),
      child:
          imageFile == null
              ? Text(hint)
              : Image.file(imageFile!, width: 300, height: 300),
    );
  }

  pickImage(ImageSource source) async {
    var selectedImage = await ImagePicker().pickImage(source: source);
    setState(() {
      imageFile = selectedImage != null ? File(selectedImage.path) : null;
    });
  }

  Widget imageChooser() {
    return Center(
      child: Column(
        children: [
          imageDefault(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
            child: const Text(
              'Escoger Imágen',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => pickImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Widget sendButton(Function onSendPressed) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(7.0),
              child: Icon(Icons.send, color: Colors.white),
            ),
            Text('Enviar', style: TextStyle(color: Colors.white)),
          ],
        ),
        onPressed: () => {onSendPressed()},
      ),
    );
  }

  void validateForm() {
    formKey.currentState?.validate();
  }

  String? validateText(String value, String message) {
    return (value.isEmpty) ? message : null;
  }

  String? validateAge(String value, String message) {
    String pattern = r'(^[0-9]+$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return message;
    } else if (!regExp.hasMatch(value)) {
      return 'La edad debe ser un número';
    } else {
      return null;
    }
  }
}
