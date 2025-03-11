import 'dart:convert';

import 'package:demo/models/StatusPet.dart';
import 'package:demo/models/TypePet.dart';

class Pet {
  int id;
  String name;
  String description;
  int age;
  String image;
  TypePet type;
  StatusPet status;

  Pet({
    required this.id,
    required this.name,
    required this.description,
    required this.age,
    required this.image,
    required this.type,
    required this.status,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      age: json['age'],
      image: json['image'],
      type: TypePet.fromJson(json['type']),
      status: StatusPet.fromJson(json['status']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'age': age,
    'image': image,
    'status': status.toJson(),
    'type': type.toJson(),
  };
}
