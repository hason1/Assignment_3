class Person {
  String id;
  String name;
  String person_number;
  String? password;
  String? role;

  Person({required this.id, required this.name, required this.person_number, this.password, this.role});

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "person_number": person_number, 'password': password ?? '', 'role': role ?? ''};
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      person_number: json['person_number'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
