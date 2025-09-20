import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared/shared.dart';
import 'package:http/http.dart' as http;

class ParkingRepository {
  static final List<Parking> _parkings = [];

  static Future<bool> add(Parking parking, {String host = 'localhost'}) async{
    final uri = Uri.parse("http://$host:8080/parking");

    Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parking.toJson()));

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

  static Future<List<Parking>> get_all({String host = 'localhost'}) async{
    final uri = Uri.parse("http://$host:8080/parking");

    Response response = await http.get(uri,
      headers: {'Content-Type': 'application/json'},);
    final json = jsonDecode(response.body);

    return (json as List).map((e) => Parking.fromJson(e)).toList();
  }

  static Future<Parking?> get_parking(String id_or_number, {String host = 'localhost'}) async{
    final uri = Uri.parse("http://$host:8080/parking/${id_or_number}");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    if(json != null){
      return Parking.fromJson(json);
    }
    else return null;
  }

  static Future<bool> update(Parking updatedParking, {String host = 'localhost'}) async{
    final uri = Uri.parse("http://$host:8080/parking/${updatedParking.id}");

    Response response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedParking.toJson()));

    final result = jsonDecode(response.body);

    return result;
  }

  static Future<bool> delete(String id,{String host = 'localhost'}) async{
    final uri = Uri.parse("http://$host:8080/parking/${id}");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final result = jsonDecode(response.body);

    return result;
  }
}
