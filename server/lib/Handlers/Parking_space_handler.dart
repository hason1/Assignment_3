import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:server/File_helper.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

// Parking spaces server request handler
class parking_space_handler{
  static String path = "./parking_spaces.json";

  static Future<Response> add_parking_space(Request request) async {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    ParkingSpace parking_space = ParkingSpace.fromJson(json);

    final success = await file_helper.create(path: path, json_data: parking_space.toJson());

    return Response.ok(
      jsonEncode(success),
      headers: {'Content-Type': 'application/json'},
    );

  }

  static Future<Response> get_parking_spaces(Request request) async {
    final items = await file_helper.getAll(path: path,);
    List<ParkingSpace> parking_spaces = items.map((json) => ParkingSpace.fromJson(json)).toList();

    final payload = parking_spaces.map((e) => e.toJson()).toList();

    return Response.ok(
      jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future<Response> update_parking_space(Request request) async {
    String? id = request.params["id"];
    bool success = false;
    if (id != null) {
      final data = await request.readAsString();
      final json = jsonDecode(data);
      ParkingSpace? parking_space = ParkingSpace.fromJson(json);

      success = await file_helper.update(path: path, id: id, json_data: parking_space.toJson());
    }

    return Response.ok(
      jsonEncode(success),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future<Response> delete_parking_space(Request request) async {
    String? id = request.params["id"];

    bool success = false;
    if (id != null) {
      success = await file_helper.delete(path: path, id: id);
    }

    return Response.ok(
      jsonEncode(success),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future<Response> get_parking_space(Request request) async {
    String? id = request.params["id"];

    if (id != null) {
      final items = await file_helper.getAll(path: path,);
      List<ParkingSpace> parking_spaces = items.map((json) => ParkingSpace.fromJson(json)).toList();

      for(int i=0; i<parking_spaces.length; i++){

        if(parking_spaces[i].id == id || parking_spaces[i].number == id){
          return Response.ok(
            jsonEncode(parking_spaces[i].toJson()),
            headers: {'Content-Type': 'application/json'},
          );
        }

      }
      return Response.ok(
        jsonEncode(null),
        headers: {'Content-Type': 'application/json'},
      );


    }

    return Response.ok(
      jsonEncode(null),
      headers: {'Content-Type': 'application/json'},
    );
  }
}