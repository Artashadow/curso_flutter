class TypePet {
  final int id;
  final String name;

  TypePet({required this.id, required this.name});

  factory TypePet.fromJson(Map<String, dynamic> json) {
    return TypePet(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'name': name, 'id': id};
}
