class StatusPet {
  final int id;
  final String name;

  StatusPet({required this.id, required this.name});

  factory StatusPet.fromJson(Map<String, dynamic> json) {
    return StatusPet(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'name': name, 'id': id};
}
