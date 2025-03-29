
import 'package:shared/shared.dart';

class Vehicle {
  String id;
  String registration_number;
  String type;
  String? person_id;

  Vehicle({required this.id, required this.registration_number, required this.type, this.person_id});

  Map<String, dynamic> toJson() {
    return {"id": id, "registration_number": registration_number, "type": type, "person_id": person_id};
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] ?? '',
      registration_number: json['registration_number'] ?? '',
      type: json['type'] ?? '',
      person_id: json['person_id'] ?? '',
    );
  }
}