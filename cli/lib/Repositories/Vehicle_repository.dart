import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared/shared.dart';
import 'package:http/http.dart' as http;

class VehicleRepository {

 static Future<bool> add(Vehicle vehicle) async {
   final uri = Uri.parse("http://localhost:8080/vehicles");

   Response response = await http.post(uri,
       headers: {'Content-Type': 'application/json'},
       body: jsonEncode(vehicle.toJson()));

   if(response.statusCode == 200){
     final json = jsonDecode(response.body);

     if(json != null){
       return json;
     }
     else {
       return false;
     }
   }
   else {
     return false;
   }
  }

  static Future<List<Vehicle>> get_all() async {
    final uri = Uri.parse("http://localhost:8080/vehicles");

    Response response = await http.get(uri,
      headers: {'Content-Type': 'application/json'},);
    final json = jsonDecode(response.body);

    return (json as List).map((e) => Vehicle.fromJson(e)).toList();
  }

  static Future<Vehicle?> get_vehicle(String id_or_number) async {
    final uri = Uri.parse("http://localhost:8080/vehicles/${id_or_number}");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    if(json != null){
      return Vehicle.fromJson(json);
    }
    else return null;
  }

  static Future<bool> update(Vehicle updatedVehicle) async {
    final uri = Uri.parse("http://localhost:8080/vehicles/${updatedVehicle.id}");

    Response response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedVehicle.toJson()));

    final json = jsonDecode(response.body);

    // return Person.fromJson(json);
    return json;
  }

  static Future<bool> delete(String registrationNumber) async {
    final uri = Uri.parse("http://localhost:8080/vehicles/${registrationNumber}");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    // return Person.fromJson(json);
    return json;
  }
}
