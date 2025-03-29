import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared/shared.dart';
import 'package:http/http.dart' as http;

class ParkingSpaceRepository {
  static final List<ParkingSpace> _parkingSpaces = [];

  static Future<bool> add(ParkingSpace parkingSpace) async {
    final uri = Uri.parse("http://localhost:8080/parking_spaces");

    Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parkingSpace.toJson()));

    if(response.statusCode == 200){
      final json = jsonDecode(response.body);

      if(json != null && json is bool){
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

  static Future<List<ParkingSpace>> get_all() async {
    final uri = Uri.parse("http://localhost:8080/parking_spaces");

    Response response = await http.get(uri,
      headers: {'Content-Type': 'application/json'},);
    final json = jsonDecode(response.body);

    return (json as List).map((e) => ParkingSpace.fromJson(e)).toList();
  }

  static Future<ParkingSpace?> get(String id_or_number) async {
    final uri = Uri.parse("http://localhost:8080/parking_spaces/${id_or_number}");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    if(json != null){
      return ParkingSpace.fromJson(json);
    }
    else return null;
  }

  static Future<bool> update(ParkingSpace updatedParkingSpace) async {
    final uri = Uri.parse("http://localhost:8080/parking_spaces/${updatedParkingSpace.id}");

    Response response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedParkingSpace.toJson()));

    final json = jsonDecode(response.body);

    return true;
  }

 static Future<bool> delete(String id) async {
   final uri = Uri.parse("http://localhost:8080/parking_spaces/${id}");

   Response response = await http.delete(
     uri,
     headers: {'Content-Type': 'application/json'},
   );

   final json = jsonDecode(response.body);

   return true;
  }
}
