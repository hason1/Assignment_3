import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:server/File_helper.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

// Parking server request handler
class parking_handler{
  static String path = "./parking.json";

  static Future<Response> add_parking(Request request) async {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    var parking = Parking.fromJson(json);

    final success = await file_helper.create(path: path, json_data: parking.toJson());

    return Response.ok(
      jsonEncode(success),
      headers: {'Content-Type': 'application/json'},
    );

  }

  static Future<Response> get_parkings(Request request) async {
    final items = await file_helper.getAll(path: path,);
    List<Parking> parking = items.map((json) => Parking.fromJson(json)).toList();

    final payload = parking.map((e) => e.toJson()).toList();

    return Response.ok(
      jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future<Response> update_parking(Request request) async {
    String? id = request.params["id"];

    bool success = false;
    if (id != null) {
      final data = await request.readAsString();
      final json = jsonDecode(data);
      Parking? parking = Parking.fromJson(json);

      success = await file_helper.update(path: path, id: id, json_data: parking.toJson());
    }

    return Response.ok(
      jsonEncode(success),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future<Response> delete_parking(Request request) async {
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

  static Future<Response> get_parking(Request request) async {
    String? id = request.params["id"];

    if (id != null) {
      final items = await file_helper.getAll(path: path,);
      List<Parking> parkings = items.map((json) => Parking.fromJson(json)).toList();

      for(int i=0; i<parkings.length; i++){

        if(parkings[i].id == id || parkings[i].parking_number == id){
          return Response.ok(
            jsonEncode(parkings[i].toJson()),
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