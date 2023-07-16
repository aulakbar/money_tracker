import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:money_tracker/localStorage/local_storage.dart';

class todoService {

  static Future<dynamic> approveTodo(int id) async {
    String? token = await getValueString('token');
    var headers = {'x-token': token}.cast<String, String>();
    String url = 'https://4f4c-125-164-16-190.ngrok-free.app/pocket-flow-approve/$id';
    var response = await http.put(
      Uri.parse('$url'),
      headers: headers);
      print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to approve');
    }
  }

  static Future<dynamic> deleteTodo(int id) async {
    String? token = await getValueString('token');
    var headers = {'x-token': token}.cast<String, String>();
    String url = 'https://4f4c-125-164-16-190.ngrok-free.app/pocket-flow/$id';
    var response = await http.delete(
      Uri.parse('$url'),
      headers: headers);
      print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete');
    }
  }

}