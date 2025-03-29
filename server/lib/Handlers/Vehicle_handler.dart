import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:server/File_helper.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

// Vehicle server request handler
class vehicle_handler{
  static String path = "./vehicles.json";

  static Future<Response> add_vehicle(Request request) async {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    var vehicle = Vehicle.fromJson(json);

    final success = await file_helper.create(path: path, json_data: vehicle.toJson());

    return Response.ok(
      jsonEncode(success),
      headers: {'Content-Type': 'application/json'},
    );

  }

  static Future<Response> get_vehicles(Request request) async {
    final items = await file_helper.getAll(path: path,);
    List<Vehicle> vehicles = items.map((json) => Vehicle.fromJson(json)).toList();

    final payload = vehicles.map((e) => e.toJson()).toList();

    return Response.ok(
      jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future<Response> update_vehicle(Request request) async {
    String? id = request.params["id"];

    bool success = false;
    if (id != null) {
      final data = await request.readAsString();
      final json = jsonDecode(data);
      Vehicle? vehicle = Vehicle.fromJson(json);

      success = await file_helper.update(path: path, id: id, json_data: vehicle.toJson());
    }

    return Response.ok(
      jsonEncode(success),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future<Response> delete_vehicle(Request request) async {
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

  static Future<Response> get_vehicle(Request request) async {
    String? id = request.params["id"];

    if (id != null) {
      final items = await file_helper.getAll(path: path,);
      List<Vehicle> vehicles = items.map((json) => Vehicle.fromJson(json)).toList();

      for(int i=0; i<vehicles.length; i++){

        if(vehicles[i].id == id || vehicles[i].registration_number == id){
          return Response.ok(
            jsonEncode(vehicles[i].toJson()),
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