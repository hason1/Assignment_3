
import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared/shared.dart';
import 'package:http/http.dart' as http;

// Person repository to communicate with Server
class PersonRepository {

  static Future<bool> add(Person person) async {
    final uri = Uri.parse("http://localhost:8080/persons");

    Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(person.toJson()));

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

  static Future<List<Person>> getAll() async {
    final uri = Uri.parse("http://localhost:8080/persons");

    Response response = await http.get(uri,
        headers: {'Content-Type': 'application/json'},);
    final json = jsonDecode(response.body);

    return (json as List).map((e) => Person.fromJson(e)).toList();
  }

  static Future<Person?> get_person(String id_or_number) async {
    final uri = Uri.parse("http://localhost:8080/persons/${id_or_number}");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    if(json != null){
      return Person.fromJson(json);
    }
    else return null;

  }

  static Future<bool> update(Person updatedPerson) async {
    final uri = Uri.parse("http://localhost:8080/persons/${updatedPerson.id}");

    Response response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedPerson.toJson()));

    final result = jsonDecode(response.body);

   // return Person.fromJson(json);
    return result;

  }

  static Future<bool> delete(String id) async {
    final uri = Uri.parse("http://localhost:8080/persons/${id}");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final result = jsonDecode(response.body);

    return result;
  }
}
