

import 'package:shared/shared.dart';

class Parking {
  String id;
  String parking_number;
  String vehicle_id;
  String parking_space_id;
  String person_id;
  String? start_time;
  String? end_time;

  Parking({required this.id, required this.parking_number, required this.vehicle_id, required this.parking_space_id, required this.person_id, required this.start_time, required this.end_time});

  Map<String, dynamic> toJson() {
    return {"id": id, "parking_number": parking_number, "vehicle_id": vehicle_id,
      "parking_space_id": parking_space_id, "person_id": person_id, "start_time": start_time, "end_time": end_time};
  }

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'] ?? '',
      parking_number: json['parking_number'] ?? '',
      vehicle_id: json['vehicle_id'] ?? '',
      parking_space_id: json['parking_space_id'] ?? '',
      person_id: json['person_id'] ?? '',
      start_time: json['start_time'] ?? '',
      end_time: json['end_time'] ?? '',
    );
  }
}
