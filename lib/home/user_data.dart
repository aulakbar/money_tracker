import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:money_tracker/localStorage/local_storage.dart';

class user_data {
  //Request user detail data from API
  static Future<dynamic> getUserDetail(String userId) async {
    String? token = await getValueString('token');
    var headers = {'x-token': token}.cast<String, String>();
    var response = await http.get(
      Uri.parse('https://4f4c-125-164-16-190.ngrok-free.app/users/$userId'),
      headers: headers);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user details');
    }
  }

  static Future<dynamic> getPocketFlow(String userId, int limit, String status) async {
    String? token = await getValueString('token');
    var headers = {'x-token': token}.cast<String, String>();
    String url = 'https://4f4c-125-164-16-190.ngrok-free.app/pocket-flow';
    var response = await http.get(
      Uri.parse('$url/?status=$status&user_id=$userId&is_approved=true&limit=$limit&orderby=approved&ordered=desc'),
      headers: headers);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user details');
    }
  }
}