import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:money_tracker/localStorage/local_storage.dart';

class user_data {
  //Request user detail data from API
  static Future<dynamic> getUserDetail(String id) async {
    String? token = await getValueString('token');
    var headers = {'x-token': token}.cast<String, String>();
    var response = await http.get(
      Uri.parse('https://money-tracker-production-3bd6.up.railway.app/users/$id'),
      headers: headers);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user details');
    }
  }
}