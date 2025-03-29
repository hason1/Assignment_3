import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:server/File_helper.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

// Person server request handler
class person_handler{
 static String path = "./persons.json";

  static Future<Response> add_person(Request request) async {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    var person = Person.fromJson(json);

    final success = await file_helper.create(path: path, json_data: person.toJson());

    return Response.ok(
      jsonEncode(success),
      headers: {'Content-Type': 'application/json'},
    );

  }

  static Future<Response> get_persons(Request request) async {
    final items = await file_helper.getAll(path: path,);
    List<Person> persons = items.map((json) => Person.fromJson(json)).toList();

    final payload = persons.map((e) => e.toJson()).toList();

    return Response.ok(
      jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future<Response> update_person(Request request) async {
    String? id = request.params["id"];

    bool success = false;
    if (id != null) {
      final data = await request.readAsString();
      final json = jsonDecode(data);
      Person? person = Person.fromJson(json);

       success = await file_helper.update(path: path, id: id, json_data: person.toJson());
    }
    return Response.ok(
      jsonEncode(success),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future<Response> delete_person(Request request) async {
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

  static Future<Response> get_person(Request request) async {
    String? id = request.params["id"];

    if (id != null) {
      final items = await file_helper.getAll(path: path,);
      List<Person> persons = items.map((json) => Person.fromJson(json)).toList();

      for(int i=0; i<persons.length; i++){

        if(persons[i].id == id || persons[i].person_number == id){
          return Response.ok(
            jsonEncode(persons[i].toJson()),
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